FactoryBot.define do
  factory :author do
    first_name { 'Marina' }
    last_name { 'Author' }
    email { 'marina12345@gmail.com' }
    password { 'password' }
  end
  factory :other_author do
    first_name { 'James' }
    last_name { 'Clear' }
    email { 'clear@gmail.com' }
    password { 'password1' }
  end
end
