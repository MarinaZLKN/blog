require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  test "creating_author_also_creates_associated_article" do
    author = Author.create(first_name: "Marina", last_name: "Zhilkina", email: "marina.zilkina@gmail.com", password: "password")
    article = author.articles.create(title: "Test Article", body: "This is a test article body.")

    assert_not_nil article
    assert_equal author, article.author
  end
end
