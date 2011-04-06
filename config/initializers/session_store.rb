# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_appliInterface_session',
  :secret      => 'e3ac1a564a29818d1fe5144569e0d6e6fc163d02c4dc6825035e13a62ec508d41a1a112824ea6b7353654dfbd445a53f09b028050251b9c07bd3bdc36108abc8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
