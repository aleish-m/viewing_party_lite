# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user_1 = User.create!(name:"Test_1", email:"test1@mail.com", password:"test123")
user_2 = User.create!(name:"Test_2", email:"test2@mail.com", password:"test123")
user_3 = User.create!(name:"Test_3", email:"test3@mail.com", password:"test123")