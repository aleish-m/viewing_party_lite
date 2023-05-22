# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
guest_user = User.create!(name:"Guest", email:"guest_test@mail.com", password:"test123")
user_2 = User.create!(name: Faker::Name.name, email:Faker::Internet.safe_email, password:"test234")
user_3 = User.create!(name: Faker::Name.name, email:Faker::Internet.safe_email, password:"test456")
user_4 = User.create!(name: Faker::Name.name, email:Faker::Internet.safe_email, password:"test567")
user_5 = User.create!(name: Faker::Name.name, email:Faker::Internet.safe_email, password:"test678")

party_1 = Party.create!(movie_id: 120, 
                        duration: 200, 
                        date: Faker::Date.forward(days: 40), 
                        start_time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now), host_id: user_2.id, 
                        movie_runtime: 180
                      )
party_2 = Party.create!(movie_id: 744, 
                        duration: 160, 
                        date: Faker::Date.forward(days: 40),
                        start_time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now),
                        host_id: guest_user.id, 
                        movie_runtime: 110
                      )
party_3 = Party.create!(movie_id: 122906, 
                        duration: 150, 
                        date: Faker::Date.forward(days: 40), 
                        start_time: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now), host_id: user_4.id, 
                        movie_runtime: 123
                      )

party_1.users << guest_user
party_1.users << user_3

party_2.users << guest_user
party_2.users << user_2
party_2.users << user_4
party_2.users << user_5

party_3.users << guest_user
party_3.users << user_2
party_3.users << user_3
party_3.users << user_4
party_3.users << user_5
