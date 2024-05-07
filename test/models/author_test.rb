require 'test_helper'

class AuthorTest < ActiveSupport::TestCase

  test "saving an author with valid attributes" do
    author = Author.new(first_name: "Sam", last_name: "Smith", email: "sam@mail.com", password: "password")
    assert author.save
  end
  test "creating author also creates associated article" do
    author = Author.create(first_name: "Marina", last_name: "Zhilkina", email: "marina.zilkina@gmail.com", password: "password")
    article = author.articles.create(title: "Test Article", body: "This is a test article body.")

    assert_not_nil article
    assert_equal author, article.author
  end

  test "password is hashed correctly" do
    password = "password123"
    author = Author.new(first_name: "Kate", last_name: "Hudson", email: "test@test.com", password: password)
    author.save
    assert_not_equal password, author.encrypted_password
    assert author.valid_password?(password)
  end

end
