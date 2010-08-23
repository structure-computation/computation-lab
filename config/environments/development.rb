# Settings specified here will take precedence over those in config/environment.rb

# chemin d'acces pour l'enregistrement des models
SC_MODEL_ROOT = "/share/sc2/Developpement/MODEL"
#SC_MODEL_ROOT = "/home/scproduction/MODEL"

# info sur le serveur de calcul en developpement
SC_CALCUL_SERVER = "localhost"
SC_CALCUL_PORT = 12346


# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
config.action_mailer.delivery_method = :smtp
# config.action_mailer.smtp_settings = {
#   :address => "smtp.gmail.com",
#   :port => 587,
#   :authentication => :plain,
#   :enable_starttls_auto => true,
#   :user_name => "structure.computation@gmail.com",
#   :password => "adminstruct"
# }


