FactoryBot.define do
  factory :user, class: User do
    name {Faker::Name.name}
    email {Faker::Internet.safe_email}
    password {Faker::Internet.password}
  end

  factory :user_party, class: UserParty do
    name {Faker::Name.first_name}
    email {Faker::Name.first_name}
    association :user, factory: :user
    association :party, factory: :party
  end

  factory :party, class: Party do
    movie_id {Faker::Number.within(range: 1..200)}
    duration {Faker::Number.within(range: 90..180)}
    date {Faker::Date.forward(days: 40)}
    start_time {Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)}
    movie_runtime {duration - 15}
    association :host_id, factory: :user
  end


end