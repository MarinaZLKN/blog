require "test_helper"

class AuthorsFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @author = authors(:one)
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
  end

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
    #assert_response :unprocessable_entity

  end
  test "should get edit author page" do
    sign_in @author
    get edit_author_path(@author)
    assert_response :success
  end

  # test "should update author" do
  #   sign_in @author
  #   patch author_edit_path, params: { author: { first_name: "New Name" } }
  #   assert_response :unprocessable_entity
  #   @author.reload
  #   assert_equal "Marina", @author.first_name
  # end
  test "deleting an author deletes associated articles" do

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

    delete author_path(author)

    assert_equal 0, Article.count
  end

end
