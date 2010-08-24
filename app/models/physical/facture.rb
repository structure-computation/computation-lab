class Facture < ActiveRecord::Base
  belongs_to :company
  belongs_to :credit
  belongs_to :log_abonnement
  
  
  # nouvelle facture associée à une ligne de crédit calcul
  def new_facture_calcul()
    self.facture_type = "calcul"
    self.statut = "unpaid"
    self.ref = Date.today.to_s() + "-" + self.id.to_s()  
    self.price_calcul_HT = self.credit.price
    self.price_calcul_TVA = self.price_calcul_HT * 0.196
    self.price_calcul_TTC = self.price_calcul_HT + self.price_calcul_TVA

    self.price_memory_HT = 0
    self.price_memory_TVA = 0
    self.price_memory_TTC = self.price_memory_HT + self.price_memory_TVA
    
    self.total_price_HT = self.price_calcul_HT + self.price_memory_HT
    self.total_price_TVA = self.price_calcul_TVA + self.price_memory_TVA
    self.total_price_TTC = self.total_price_HT + self.total_price_TVA
    
    #génération de la facture pdf et sauvegarde
    self.generate_pdf_facture()
    self.save
  end
  
  # nouvelle facture associée à une ligne de log_memoire
  def new_facture_memoire()
    self.facture_type = "memoire"
    self.statut = "unpaid"
    self.ref = Date.today.to_s() + "-" + self.id.to_s()  
    self.price_calcul_HT = 0
    self.price_calcul_TVA = 0
    self.price_calcul_TTC = self.price_calcul_HT + self.price_calcul_TVA

    self.price_memory_HT = self.log_abonnement.price
    self.price_memory_TVA = self.price_memory_HT * 0.196
    self.price_memory_TTC = self.price_memory_HT + self.price_memory_TVA
    
    self.total_price_HT = self.price_calcul_HT + self.price_memory_HT
    self.total_price_TVA = self.price_calcul_TVA + self.price_memory_TVA
    self.total_price_TTC = self.total_price_HT + self.total_price_TVA
    
    #génération de la facture pdf et sauvegarde
    self.generate_pdf_facture()
    self.save
  end
  
  def valid_facture_calcul()
    self.statut = "paid"
    self.paid_date = Date.today
    self.save
    self.credit.valid_credit_and_calcul_account()
  end
  
  def valid_facture_memoire()
    self.statut = "paid"
    self.paid_date = Date.today
    self.save
    self.log_abonnement.valid_log_abonnement_and_memory_account()
  end
  
  def valid_facture()
    if(self.facture_type == "calcul")
      valid_facture_calcul()
    elsif(self.facture_type == "memoire")
      valid_facture_memoire()
    end
  end
  
  #on génère le fichier pdf de la facture
  def generate_pdf_facture()
    
    @current_company = self.company
    @current_gestionnaire = @current_company.users.find(:first, :conditions => {:role => "gestionnaire"})
    pdf = Prawn::Document.new(:page_size => 'A4',:background => "#{RAILS_ROOT}/public/images/fond_facture.jpg", :margin => [0,0,0,0])
    
    pdf.font "Helvetica" 
    colors = {:black => "000000", :grey => "8d8d8d", :blue => "2a3556", :magenta => "eb4f95", :white => "ffffff"} 
    pdf.line_width = 0.75
    pdf.stroke_color colors[:white]

    logoimage = "public/images/logo.jpg" 
    pdf.bounding_box [50, 820], :width => 150, :height => 100 do
	pdf.image "public/images/logo_trans_3.png", :scale => 0.75, :position  => :left, :vposition  => :top
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
	pdf.text @current_company.name, :align => :right
	pdf.text @current_company.division, :align => :right
	pdf.text @current_company.address, :align => :right
	pdf.text @current_company.zipcode + " " + @current_company.city, :align => :right
	pdf.text @current_company.country, :align => :right
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
    if self.facture_type == 'calcul'
      # on insere les noms des lignes
      pdf.fill_color colors[:blue]
      pdf.bounding_box [50, 480], :width => 110, :height => 20 do
	  pdf.text  "Forfait de calcul :" , :align => :left, :style => :bold
      end
      pdf.bounding_box [160, 480], :width => 200, :height => 20 do
	  pdf.text  self.credit.forfait.name , :align => :left 
      end

      pdf.bounding_box [80, 465], :width => 150, :height => 45 do
	  pdf.text "Nombre de jetons standard :", :align => :left, :size => 10
	  pdf.text "Nombre de jetons tampons :", :align => :left, :size => 10
	  pdf.text "Durée de validité (mois) :", :align => :left, :size => 10
      end
      pdf.bounding_box [230, 465], :width => 100, :height => 45 do
	  pdf.text self.credit.forfait.nb_jetons.to_s(), :align => :left, :size => 10
	  pdf.text self.credit.forfait.nb_jetons_tempon.to_s(), :align => :left, :size => 10
	  pdf.text self.credit.forfait.validity.to_s(), :align => :left, :size => 10
      end

      # on insere les chiffres
      pdf.fill_color colors[:blue]
      pdf.bounding_box [360, 480], :width => 70, :height => 20 do
	  pdf.text  self.price_calcul_HT.to_s() , :align => :center
      end
      pdf.bounding_box [430, 480], :width => 70, :height => 20 do
	  pdf.text  self.price_calcul_TVA.to_s(), :align => :center
      end
      pdf.bounding_box [500, 480], :width => 70, :height => 20 do
	  pdf.text  self.price_calcul_TTC.to_s(), :align => :center
      end

      pdf.fill_color colors[:blue]
      pdf.bounding_box [360, 465], :width => 70, :height => 45 do
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
      end
      pdf.bounding_box [430, 465], :width => 70, :height => 45 do
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
      end
      pdf.bounding_box [500, 465], :width => 70, :height => 45 do
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
      end

    # si le type de facture est un memoire ----------------------------------------------------------------
    elsif self.facture_type == 'memoire'
      # on insere les noms des lignes
      pdf.fill_color colors[:blue]
      pdf.bounding_box [50, 480], :width => 200, :height => 20 do
	  pdf.text  "Abonnement espace mémoire : " , :align => :left, :style => :bold
      end
      pdf.bounding_box [250, 480], :width => 120, :height => 20 do
	  pdf.text  self.log_abonnement.abonnement.name , :align => :left 
      end

      pdf.bounding_box [80, 465], :width => 150, :height => 45 do
	  pdf.text "mémoire assigné :", :align => :left, :size => 10
	  pdf.text "niveau de sécurité : ", :align => :left, :size => 10
	  pdf.text "nombre d'utilisateurs maximum :", :align => :left, :size => 10
      end
      pdf.bounding_box [230, 465], :width => 100, :height => 45 do
	  pdf.text self.log_abonnement.abonnement.assigned_memory.to_s(), :align => :left, :size => 10
	  pdf.text self.log_abonnement.abonnement.security_level.to_s(), :align => :left, :size => 10
	  pdf.text self.log_abonnement.abonnement.nb_max_user.to_s(), :align => :left, :size => 10
      end

      # on insere les chiffres
      pdf.fill_color colors[:blue]
      pdf.bounding_box [360, 480], :width => 70, :height => 20 do
	  pdf.text  self.price_memory_HT.to_s() , :align => :center
      end
      pdf.bounding_box [430, 480], :width => 70, :height => 20 do
	  pdf.text  self.price_memory_TVA.to_s(), :align => :center
      end
      pdf.bounding_box [500, 480], :width => 70, :height => 20 do
	  pdf.text  self.price_memory_TTC.to_s(), :align => :center
      end

      pdf.fill_color colors[:blue]
      pdf.bounding_box [360, 465], :width => 70, :height => 45 do
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
      end
      pdf.bounding_box [430, 465], :width => 70, :height => 45 do
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
	  pdf.text " - ", :align => :center, :size => 10
      end
      pdf.bounding_box [500, 465], :width => 70, :height => 45 do
	  pdf.text " - ", :align => :center, :size => 10
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
