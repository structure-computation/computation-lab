# Load the rails application
# Encoding.default_internal = 'UTF-8'
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SCInterface::Application.initialize!

Encoding.default_external = Encoding::UTF_8
# Conservé de l'ancien fichier(rails V2.3) pour mémoire temporairement.
  # config.load_paths += Dir["#{RAILS_ROOT}/app/models/**/**"]
  # 
  # 
  # config.active_record.observers = :user_observer
  # 
  # # Configuration de l'envoi des mails
  # config.action_mailer.delivery_method    = :sendmail
  # config.action_mailer.perform_deliveries = true
  # config.time_zone = 'UTC'
