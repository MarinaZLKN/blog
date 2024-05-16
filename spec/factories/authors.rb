FactoryBot.define do
  factory :author do
    first_name { 'Marina' }
    last_name { 'Author' }
    #email { 'marina123445@gmail.com' }
    sequence(:email) { |n| "author#{n}@example.com" }
    password { "password1" }
    factory :author_with_devise do
      password { Devise.friendly_token[0, 20] }
    end
  end
  factory :other_author do
    first_name { 'James' }
    last_name { 'Clear' }
    email { Faker::Internet.unique.email }
    password { "password1" }
    factory :other_author_with_devise do
      password { Devise.friendly_token[0, 20] }
    end
  end
end
