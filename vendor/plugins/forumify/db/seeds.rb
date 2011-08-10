# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

user1 = User.new(                              
  :username              => 'stephie'
  :email                 => 'hello@world.com',
  :password              => 'helloworld',
  :password_confirmation => 'helloworld'
)
user1.save!

user2 = User.new( 
  :username              => 'chou' 
  :email                 => 'toto@toto.com',
  :password              => 'coucou',
  :password_confirmation => 'coucou'
)
user2.save!