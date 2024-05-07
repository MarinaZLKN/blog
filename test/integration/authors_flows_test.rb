require "test_helper"

class AuthorsFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @author = authors(:one)
    @author2 = authors(:two)
    sign_in authors(:one)
  end

  test "should create author" do
    sign_out :author
    assert_difference('Author.count', 1) do
      post authors_path, params: { author: {
        first_name: 'Alice',
        last_name: 'Smith',
        email: "alice+#{Time.now.to_i}@example.com",
        password: 'password123',
        password_confirmation: 'password123'
        } }
    end

    assert_redirected_to root_path
    assert_equal "Welcome! You have signed up successfully.", flash[:notice]
  end

  # test "should not create author without required attributes" do
  #   assert_no_difference('Author.count') do
  #     post authors_path, params: { author: { last_name: "Kask", email: "kask@test.com", password: 'password123', password_confirmation: 'password123' } }
  #   end
  #   assert_response :unprocessable_entity
  #   assert_equal "First name can't be blank."

  #   assert_no_difference('Author.count') do
  #     post authors_path, params: { author: { first_name: "Tom", email: "tom@test.com", password: 'password123', password_confirmation: 'password123'  } }
  #   end
  #   assert_response :unprocessable_entity
  #   assert_equal "Last name can't be blank."

  #   assert_no_difference('Author.count') do
  #     post authors_path, params: { author: { first_name: "Tom", last_name: "Kask", password: 'password123', password_confirmation: 'password123'  } }
  #   end
  #   assert_response :unprocessable_entity
  #   assert_equal "Email can't be blank"
  # end


  test "should not create an author with existing email" do
    duplicate_email = @author.email
    assert_no_difference('Author.count') do
      post authors_path, params: { author: {
        first_name: 'Bob',
        last_name: 'Johnson',
        email: duplicate_email,
        password: 'password123',
        password_confirmation: 'password123'
        } }
    end
    follow_redirect!

  end

  test "existing author can successfully sign in with correct credentials" do
    sign_in @author
    get root_path
    assert_response :success
    assert_select 'button', 'Log Out'
  end


  test "log in is not allowed with incorrect credentials" do
    post author_session_path, params: { author: {
      email: "random@email.com",
      password: 'wrong_password'
    } }

    assert_response :redirect
    #assert_equal "Invalid Email or password.", flash[:notice]
    #assert_response :unprocessable_entity

  end
  test "should get edit author page" do
    sign_in @author
    get edit_author_path(@author)
    assert_response :success
  end

  test "should update author" do
    sign_in @author
    patch author_path(@author), params: { author: { first_name: "New Name" } }
    assert_response :found
    @author.reload
    assert_equal "New Name", @author.first_name
  end

  test "should destroy author" do
    sign_in @author

    assert_difference('Author.count', -1) do
      delete author_path(@author)
    end

    assert_redirected_to authors_path
    assert_equal "Author was successfully deleted.", flash[:notice]
  end

  test "deleting an author deletes associated articles too" do

    author = Author.create!(
      first_name: "user",
      last_name: "new",
      email: "new@mail.com",
      password: "password"
    )

    sign_in author

    author.articles.create!(
      title: "First article",
      body: "First article body",
      status: "public"
    )

    author.articles.create!(
      title: "Second article",
      body: "Second article body",
      status: "public"
    )

    assert_equal 2, Article.count

    assert_difference('Author.count', -1) do
      delete author_path(author)
    end

    assert_equal 0, Article.count
  end

  test "should return full name" do
    author = Author.new(first_name: "Marina", last_name: "Test")
    assert_equal "Marina Test", author.full_name
  end


  test "authenticated author cannot update other authors' articles" do
    author = authors(:one)
    other_author = authors(:two)
    article = author.articles.create!(title: "Test Article", body: "Test article body", status: "public")

    sign_in(other_author)

    patch article_path(article), params: { article: { title: "New Title" } }
    assert_redirected_to article_path(article)
    assert_equal 'You can edit only your own articles. :)', flash[:alert]
  end

  test "authenticated author cannot delete other authors' articles" do
    author = authors(:one)
    other_author = authors(:two)
    article = author.articles.create!(title: "Test Article", body: "Test article body", status: "public")

    sign_in(other_author)

    delete article_path(article)
    assert_redirected_to article_path(article)
    assert_equal 'You can delete only articles that belong to you.', flash[:alert]
  end
end
