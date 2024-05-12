FactoryBot.define do
  factory :article do
    title { "Example Article" }
    body { "Lorem ipsum dolor sit amet" }
    status {"public"}
    association :author, factory: :author
  end
end
