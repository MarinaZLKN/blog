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
end
