# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
AdminUser.find_or_create_by(email: "admin@example.com") do |au|
  au.name = 'admin'
  au.password = 'adminadmin'
  au.password_confirmation = 'adminadmin'
end

Dir[Rails.root.join('db/seeds/*.rb')].each do |file|
  puts "Processing #{file.split('/').last}"
  require file
end
