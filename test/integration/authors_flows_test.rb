require "test_helper"

class AuthorsFlowsTest < ActionDispatch::IntegrationTest

  test "registration creates a new author in the database with valid data" do
    get new_author_registration_path
    assert_response :success

    assert_difference 'Author.count', 1 do
      post author_registration_path, params: { author: {
        first_name: "Marina",
        last_name: "Zhilkina",
        email: "marina@gmail.com",
        password: "password",
        password_confirmation: "password"
      } }
    end

    assert_redirected_to root_path
    follow_redirect!

    assert_select 'p', 'Welcome! You have signed up successfully.'
  end


  test "registration does not create a new author in the database with invalid data" do
    get new_author_registration_path
    assert_response :success

    assert_no_difference 'Author.count' do
      post author_registration_path, params: { author: {
        first_name: "",
        last_name: "Doe",
        email: "john@example.com",
        password: "password",
        password_confirmation: "password"
      } }
    end

    assert_response :unprocessable_entity
    assert_select "div#error_explanation"
  end
  test "existing email prevents registration" do
    existing_author = Author.create(first_name: "User", last_name: "New", email: "user@mail.com", password: "password")

    get new_author_registration_path
    assert_response :success

    assert_no_difference 'Author.count' do
      post author_registration_path, params: { author: {
        first_name: "Kate",
        last_name: "Smith",
        email: existing_author.email,
        password: "password",
        password_confirmation: "password"
      } }
    end

    assert_response :unprocessable_entity
    assert_select 'div#error_explanation', /Email has already been taken/
  end

  test "existing author can successfully sign in with correct credentials" do
    author = Author.create(first_name: "Marina", last_name: "Zhilkina", email: "marina@gmail.com", password: "password")

    get new_author_session_path
    assert_response :success

    post author_session_path, params: { author: { email: author.email, password: author.password } }
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_select "p", "Signed in successfully."
  end

  test "sign in is not allowed with incorrect credentials" do
    author = Author.create(first_name: "New", last_name: "User", email: "user@gmail.com", password: "password")

    get new_author_session_path
    assert_response :success

    post author_session_path, params: { author: { email: author.email, password: "incorrect_password" } }
    assert_response :unprocessable_entity
    assert_select "p", "Invalid Email or password."
  end
end
