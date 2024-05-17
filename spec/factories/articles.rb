FactoryBot.define do
  factory :article do
    title { "Example Article" }
    body { "Lorem ipsum dolor sit amet" }
    status {"public"}
    association :author, factory: :author
  end
  factory :other_article do
    title { "Another example Article" }
    body { "Lorem ipsum dolor sit amet vol 2" }
    status {"public"}
    association :other_author, factory: :author
  end
end
