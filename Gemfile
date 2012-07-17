source :rubygems

gem 'rails'       , '~>3.0.0'
gem 'mysql'       , '~>2.8.1'
gem 'delayed_job' , '~>2.1.4'
gem 'mongrel'     , '~>1.1.5' 

# gem 'resque'  

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
gem 'therubyracer', :platforms => :ruby

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:

# Note : pour les gem de test on utilise les dernières versions (aux developpeur de gerer les pb à posteriori plutôt que
# se limiter à priori)
group :development, :test do
  # gem 'webrat'
  gem 'ruby-debug'          , :require => 'ruby-debug'
  
  gem 'capybara'            #, '=0.3.9'
  gem 'rspec'
  gem 'rspec-rails'         #, '~>2.2.1'
  gem 'cucumber'            #, '~>0.9.4'
  gem 'cucumber-rails'      #, '~>0.3.2'
  gem 'database_cleaner'
  gem 'haml_scaffold'       #, '~>1.1.0'
  gem 'shoulda'             #, '~>2.11.3'
  gem 'email_spec'          #, '~>1.0.0'
  gem 'rcov'                #, '~>0.9.9'
  gem 'jasmine'
                            #
  gem 'autotest-rails'      #, '~>4.1.0'
  gem 'autotest'            #, '~>4.4.1'
  
  # Utilisation des générateurs haml de devise.
  gem 'hpricot'               , '~>0.8.4'
  gem 'ruby_parser'           , '~>2.0.6'
end
