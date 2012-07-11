require 'factory_girl'

 Factory.define(:user) do |o|
   o.name "Jérémy"
   o.email "j.bellec@structure-computation.com"
 end