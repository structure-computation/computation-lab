# TODO: supprimer ce fichier ou lui donner un rôle.
class FactureObserver < ActiveRecord::Observer
#   def after_create(facture)  
#     # ecripture de la facture au format pdf
#     facture.reload
#     facture.ref = Date.today.to_s() + "-" + facture.id.to_s() 
#     @current_company = facture.company
#     @current_gestionnaire = @current_company.users.find(:first, :conditions => {:role => "gestionnaire"})
#     
#     pdf = Prawn::Document.new(:page_size => 'A4',:background => "#{RAILS_ROOT}/public/images/fond_facture.jpg", :margin => [0,0,0,0])
#      
#     pdf.font "Helvetica" 
#     colors = {:black => "000000", :grey => "8d8d8d", :blue => "2a3556", :magenta => "eb4f95", :white => "ffffff"} 
#     pdf.line_width = 0.75
#     pdf.stroke_color colors[:white]
# 
#     logoimage = "public/images/logo.jpg" 
#     pdf.bounding_box [50, 820], :width => 150, :height => 100 do
# 	pdf.image "public/images/logo_trans_3.png", :scale => 0.75, :position  => :left, :vposition  => :top
#     end
# 
#     pdf.fill_color colors[:grey]
#     pdf.bounding_box [400, 800], :width => 150, :height => 100 do
# 	pdf.text "Facture", :size => 20, :align => :right
#     end
#     pdf.fill_color colors[:black]
#     pdf.stroke_horizontal_line(0,595)
# 
# 
#     pdf.bounding_box([50, 650], :width => 100, :height => 150) do
# 	pdf.fill_color colors[:blue]
# 	pdf.text "Référence : " , :align => :left , :style => :bold
# 	pdf.move_down(5)
# 	pdf.text "Date : ", :align => :left , :style => :bold
# 	pdf.move_down(5)
# 	pdf.text "Statut : " , :align => :left, :style => :bold
#     end
# 
#     pdf.bounding_box [150, 650], :width => 100, :height => 150 do
# 	pdf.fill_color colors[:black]
# 	pdf.text facture.ref , :align => :left
# 	pdf.move_down(5)
# 	pdf.text facture.created_at.to_date.to_s(), :align => :left
# 	pdf.move_down(5)
# 	pdf.text facture.statut, :align => :left
#     end
# 
#     pdf.bounding_box [300, 650], :width => 245, :height => 150 do
# 	pdf.text @current_gestionnaire.firstname + " " + @current_gestionnaire.lastname , :align => :right
# 	pdf.text @current_company.name, :align => :right
# 	pdf.text @current_company.division, :align => :right
# 	pdf.text @current_company.address, :align => :right
# 	pdf.text @current_company.zipcode + " " + @current_company.city, :align => :right
# 	pdf.text @current_company.country, :align => :right
#     end
# 
#     #entete du tableau des prix
#     pdf.fill_color colors[:grey]
#     pdf.bounding_box [360, 500], :width => 70, :height => 20 do
# 	pdf.text "€ HT ", :align => :center
#     end
#     pdf.bounding_box [430, 500], :width => 70, :height => 20 do
# 	pdf.text "€ TVA ", :align => :center
#     end
#     pdf.bounding_box [500, 500], :width => 70, :height => 20 do
# 	pdf.text "€ TTC ", :align => :center
#     end
# 
#     # si le type de facture est un calcul ----------------------------------------------------------------
#     if facture.facture_type == 'calcul'
#       # on insere les noms des lignes
#       pdf.fill_color colors[:blue]
#       pdf.bounding_box [50, 480], :width => 110, :height => 20 do
# 	  pdf.text  "Forfait de calcul :" , :align => :left, :style => :bold
#       end
#       pdf.bounding_box [160, 480], :width => 200, :height => 20 do
# 	  pdf.text  facture.credit.forfait.name , :align => :left 
#       end
# 
#       pdf.bounding_box [80, 465], :width => 150, :height => 45 do
# 	  pdf.text "Nombre de jetons standard :", :align => :left, :size => 10
# 	  pdf.text "Nombre de jetons tampons :", :align => :left, :size => 10
# 	  pdf.text "Durée de validité (mois) :", :align => :left, :size => 10
#       end
#       pdf.bounding_box [230, 465], :width => 100, :height => 45 do
# 	  pdf.text facture.credit.forfait.nb_jetons.to_s(), :align => :left, :size => 10
# 	  pdf.text facture.credit.forfait.nb_jetons_tempon.to_s(), :align => :left, :size => 10
# 	  pdf.text facture.credit.forfait.validity.to_s(), :align => :left, :size => 10
#       end
# 
#       # on insere les chiffres
#       pdf.fill_color colors[:blue]
#       pdf.bounding_box [360, 480], :width => 70, :height => 20 do
# 	  pdf.text  facture.price_calcul_HT.to_s() , :align => :center
#       end
#       pdf.bounding_box [430, 480], :width => 70, :height => 20 do
# 	  pdf.text  facture.price_calcul_TVA.to_s(), :align => :center
#       end
#       pdf.bounding_box [500, 480], :width => 70, :height => 20 do
# 	  pdf.text  facture.price_calcul_TTC.to_s(), :align => :center
#       end
# 
#       pdf.fill_color colors[:blue]
#       pdf.bounding_box [360, 465], :width => 70, :height => 45 do
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
#       end
#       pdf.bounding_box [430, 465], :width => 70, :height => 45 do
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
#       end
#       pdf.bounding_box [500, 465], :width => 70, :height => 45 do
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
#       end
# 
#     # si le type de facture est un memoire ----------------------------------------------------------------
#     elsif facture.facture_type == 'memoire'
#       # on insere les noms des lignes
#       pdf.fill_color colors[:blue]
#       pdf.bounding_box [50, 480], :width => 200, :height => 20 do
# 	  pdf.text  "Abonnement espace mémoire : " , :align => :left, :style => :bold
#       end
#       pdf.bounding_box [250, 480], :width => 120, :height => 20 do
# 	  pdf.text  facture.log_abonnement.abonnement.name , :align => :left 
#       end
# 
#       pdf.bounding_box [80, 465], :width => 150, :height => 45 do
# 	  pdf.text "mémoire assigné :", :align => :left, :size => 10
# 	  pdf.text "niveau de sécurité : ", :align => :left, :size => 10
# 	  pdf.text "nombre d'utilisateurs maximum :", :align => :left, :size => 10
#       end
#       pdf.bounding_box [230, 465], :width => 100, :height => 45 do
# 	  pdf.text facture.log_abonnement.abonnement.assigned_memory.to_s(), :align => :left, :size => 10
# 	  pdf.text facture.log_abonnement.abonnement.security_level.to_s(), :align => :left, :size => 10
# 	  pdf.text facture.log_abonnement.abonnement.nb_max_user.to_s(), :align => :left, :size => 10
#       end
# 
#       # on insere les chiffres
#       pdf.fill_color colors[:blue]
#       pdf.bounding_box [360, 480], :width => 70, :height => 20 do
# 	  pdf.text  facture.price_memory_HT.to_s() , :align => :center
#       end
#       pdf.bounding_box [430, 480], :width => 70, :height => 20 do
# 	  pdf.text  facture.price_memory_TVA.to_s(), :align => :center
#       end
#       pdf.bounding_box [500, 480], :width => 70, :height => 20 do
# 	  pdf.text  facture.price_memory_TTC.to_s(), :align => :center
#       end
# 
#       pdf.fill_color colors[:blue]
#       pdf.bounding_box [360, 465], :width => 70, :height => 45 do
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
#       end
#       pdf.bounding_box [430, 465], :width => 70, :height => 45 do
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
#       end
#       pdf.bounding_box [500, 465], :width => 70, :height => 45 do
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
# 	  pdf.text " - ", :align => :center, :size => 10
#       end
#     end
# 
#     # totale de la facture
#     pdf.stroke_color colors[:blue]
#     pdf.stroke_horizontal_line(200,570) 
# 
#     pdf.bounding_box [210, 410], :width => 70, :height => 20 do
# 	pdf.text  "Total" , :align => :center, :style => :bold
#     end
#     pdf.bounding_box [360, 410], :width => 70, :height => 20 do
# 	pdf.text  facture.total_price_HT.to_s() , :align => :center, :style => :bold
#     end
#     pdf.bounding_box [430, 410], :width => 70, :height => 20 do
# 	pdf.text  facture.total_price_TVA.to_s(), :align => :center, :style => :bold
#     end
#     pdf.bounding_box [500, 410], :width => 70, :height => 20 do
# 	pdf.text  facture.total_price_TTC.to_s(), :align => :center, :style => :bold
#     end
# 
#     # mentions légales
#     pdf.bounding_box [50, 380], :width => 500, :height => 40 do
#     end
#     pdf.stroke_color colors[:white]
#     pdf.stroke_horizontal_line(0,595) 
#     
#     #enregistrement du fichier pdf
#     facture.save
#     pdf.render_file "#{SC_FACTURE_ROOT}/facture_" + facture.id + ".pdf"
#     
#   end
end

