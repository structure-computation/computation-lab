require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']
source :rubygems

gem 'rails'       , '~>3.0.0'
gem 'mysql'       , '~>2.8.1'

gem 'delayed_job' , '~>2.1.4'
gem 'haml'        , '~>3.1.1'
gem 'barista'     , '~>1.2.1'  # Attention, haml doit être chargé AVANT barrista.
gem 'prawn'       , '~>0.8.4'

gem 'jquery-rails', '~>1.0.12'
gem 'transitions' , '~>0.0.9'
gem 'warden'      , '~>1.0.3'
gem 'devise'      , '~>1.1.8'
gem 'formtastic'  , '~>1.2.3'
gem 'acts_as_api' , '~>0.3.5'
gem 'compass'     , '>= 0.11.5'
gem 'compass-susy-plugin'
gem 'inherited_resources'
# gem 'capistrano'

group :development, :test do
  gem 'ruby-debug'          , :platforms => :ruby_18
  gem 'ruby-debug19'        , :platforms => :ruby_19
  gem 'rspec'               , '~> 2.2.0'
  gem 'rspec-rails'         , '~>2.2.1'
  gem 'database_cleaner'
  gem "haml-rails"          , ">= 0.3.4"
  gem 'haml_scaffold'       , '~>1.1.0'
  
  
end

group  :test do
  # gem 'factory_girl_rails'  #, '~>1.2'    
  gem 'capybara'            #, '=0.3.9'
  gem 'cucumber'            #, '~>0.9.4'
  gem 'cucumber-rails'      #, '~>0.3.2'
  gem 'shoulda'             #, '~>2.11.3'
  gem 'email_spec'          #, '~>1.0.0'
  gem 'rcov'                #, '~>0.9.9'
  # gem 'jasmine'
  
  # Utilisation des générateurs haml de devise.
  gem 'hpricot'               , '~>0.8.4'
  gem 'ruby_parser'           , '~>2.0.6'
end
