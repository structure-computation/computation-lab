class Bill < ActiveRecord::Base
  belongs_to :workspace
  belongs_to :credit
  belongs_to :log_abonnement
  belongs_to :company
  
  scope :from_workspace , lambda { |workspace_id|
     where(:workspace_id => workspace_id)
   }
  
  # nouvelle facture associée à une ligne de crédit calcul
  def new_token_bill()
    self.bill_type = "token"
    self.statut = "unpaid"
    self.description = self.credit.forfait.name
    self.ref = Date.today.to_s() + "-" + self.id.to_s()  
    self.token_price_HT = self.credit.token_price
    self.global_price_HT = self.credit.global_price
    self.global_price_TVA = self.credit.global_price * 0.196
    self.global_price_TTC = self.credit.global_price * 1.196
    
    self.total_price_HT = self.global_price_HT
    self.total_price_TVA = self.global_price_TVA
    self.total_price_TTC = self.global_price_TTC
    
    #génération de la facture pdf et sauvegarde
    self.generate_bill_pdf()
    self.save
  end
  
  def valid_bill()
    if self.statut != "paid"
      self.statut = "paid"
      self.paid_date = Date.today
      self.save
      self.credit.valid_credit()
    end
  end
  
  def cancel_bill()
    self.statut = "canceled"
    self.save
    self.credit.cancel_credit()
  end
  
  #on génère le fichier pdf de la facture
  def generate_bill_pdf()
    
    @current_workspace = self.workspace
    @current_member_gestionnaire = @current_workspace.user_workspace_memberships.find(:first, :conditions => {:manager => 1})
    @current_gestionnaire = @current_member_gestionnaire.user
    pdf = Prawn::Document.new(:page_size => 'A4', :margin => [0,0,0,0])
    
    pdf.font "Helvetica" 
    colors = {:black => "000000", :grey => "8d8d8d", :blue => "2a3556", :magenta => "eb4f95", :white => "ffffff"} 
    pdf.line_width = 0.75
    pdf.stroke_color colors[:white]

    logoimage = "public/images/logo.jpg" 
    pdf.bounding_box [50, 820], :width => 150, :height => 100 do
	pdf.image "public/images/Logo_StructureComputation_gris.png", :scale => 0.75, :position  => :left, :vposition  => :top
    end

    pdf.fill_color colors[:grey]
    pdf.bounding_box [400, 800], :width => 150, :height => 100 do
	pdf.text "Facture", :size => 20, :align => :right
    end
    pdf.fill_color colors[:black]
    pdf.stroke_horizontal_line(0,595)


    pdf.bounding_box([50, 650], :width => 100, :height => 150) do
	pdf.fill_color colors[:blue]
	pdf.text "Référence : " , :align => :left , :style => :bold
	pdf.move_down(5)
	pdf.text "Date : ", :align => :left , :style => :bold
	pdf.move_down(5)
	pdf.text "Statut : " , :align => :left, :style => :bold
    end

    pdf.bounding_box [150, 650], :width => 100, :height => 150 do
	pdf.fill_color colors[:black]
	pdf.text self.ref , :align => :left
	pdf.move_down(5)
	pdf.text self.created_at.to_date.to_s(), :align => :left
	pdf.move_down(5)
	pdf.text self.statut, :align => :left
    end

    pdf.bounding_box [300, 650], :width => 245, :height => 150 do
	pdf.text @current_gestionnaire.firstname + " " + @current_gestionnaire.lastname , :align => :right
	pdf.text @current_workspace.name, :align => :right
        pdf.text "  ", :align => :right
	pdf.text self.company.name, :align => :right
	pdf.text self.company.address, :align => :right
	pdf.text self.company.zipcode + " " + self.company.city, :align => :right
	pdf.text self.company.phone, :align => :right
    end

    #entete du tableau des prix
    pdf.fill_color colors[:grey]
    pdf.bounding_box [360, 500], :width => 70, :height => 20 do
	pdf.text "€ HT ", :align => :center
    end
    pdf.bounding_box [430, 500], :width => 70, :height => 20 do
	pdf.text "€ TVA ", :align => :center
    end
    pdf.bounding_box [500, 500], :width => 70, :height => 20 do
	pdf.text "€ TTC ", :align => :center
    end

    # si le type de facture est un calcul ----------------------------------------------------------------
    if self.bill_type == 'token'
      # on insere les noms des lignes
      pdf.fill_color colors[:blue]
      pdf.bounding_box [50, 480], :width => 110, :height => 20 do
	  pdf.text  "Forfait de calcul :" , :align => :left, :style => :bold
      end
      pdf.bounding_box [160, 480], :width => 200, :height => 20 do
	  pdf.text  self.credit.forfait.name , :align => :left 
      end

      pdf.bounding_box [80, 465], :width => 150, :height => 45 do
	  pdf.text "Nombre de jetons :", :align => :left, :size => 10
	  pdf.text "Durée de validité (mois) :", :align => :left, :size => 10
      end
      pdf.bounding_box [230, 465], :width => 100, :height => 45 do
	  pdf.text self.credit.nb_token.to_s(), :align => :left, :size => 10
	  pdf.text self.credit.forfait.validity.to_s(), :align => :left, :size => 10
      end

      # on insere les chiffres
      pdf.fill_color colors[:blue]
      pdf.bounding_box [360, 480], :width => 70, :height => 20 do
	  pdf.text  self.global_price_HT.to_s() , :align => :center
      end
      pdf.bounding_box [430, 480], :width => 70, :height => 20 do
	  pdf.text  self.global_price_TVA.to_s(), :align => :center
      end
      pdf.bounding_box [500, 480], :width => 70, :height => 20 do
	  pdf.text  self.global_price_TTC.to_s(), :align => :center
      end

      pdf.fill_color colors[:blue]
      pdf.bounding_box [360, 465], :width => 70, :height => 45 do
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
      end
      pdf.bounding_box [430, 465], :width => 70, :height => 45 do
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
      end
      pdf.bounding_box [500, 465], :width => 70, :height => 45 do
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
      end
    end

    # totale de la facture
    pdf.stroke_color colors[:blue]
    pdf.stroke_horizontal_line(200,570) 

    pdf.bounding_box [210, 410], :width => 70, :height => 20 do
	pdf.text  "Total" , :align => :center, :style => :bold
    end
    pdf.bounding_box [360, 410], :width => 70, :height => 20 do
	pdf.text  self.total_price_HT.to_s() , :align => :center, :style => :bold
    end
    pdf.bounding_box [430, 410], :width => 70, :height => 20 do
	pdf.text  self.total_price_TVA.to_s(), :align => :center, :style => :bold
    end
    pdf.bounding_box [500, 410], :width => 70, :height => 20 do
	pdf.text  self.total_price_TTC.to_s(), :align => :center, :style => :bold
    end

    # mentions légales
    pdf.bounding_box [50, 380], :width => 500, :height => 40 do
    end
    pdf.stroke_color colors[:white]
    pdf.stroke_horizontal_line(0,595)     
    
    #enregistrement du fichier pdf
    pdf.render_file "#{SC_FACTURE_ROOT}/facture_" + self.id.to_s() + ".pdf"
    
  end
end
