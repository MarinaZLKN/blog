require "application_system_test_case"

class DevisesTest < ApplicationSystemTestCase
  test "signing up the auhtor" do
    visit root_path

    click_on "New article"
    click_on "Sign up"

    fill_in "First name", with: "Marina"
    fill_in "Last name", with: "Zhilkina"
    fill_in "Email", with: "marina.zilkina@gmail.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_on "Sign up"

    assert_text "Welcome! You have signed up successfully."
  end

  test "signing up the author with existing email" do

    Author.create!(
      first_name: "Alexa",
      last_name: "Murmur",
      email: "marina.zilkina@gmail.com",
      password: "password"
    )

    visit root_path
    click_on "New article"
    click_on "Sign up"

    fill_in "First name", with: "Another"
    fill_in "Last name", with: "User"
    fill_in "Email", with: "marina.zilkina@gmail.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_on "Sign up"

    assert_text "Email has already been taken"
  end
  test "signing in the auhtor" do
    Author.create!(
      first_name: "Marina",
      last_name: "Zhilkina",
      email: "marina.zilkina@gmail.com",
      password: "password"
    )
    visit root_path

    click_on "New article"
    assert_text "You need to sign in or sign up before continuing."


    fill_in "Email", with: "marina.zilkina@gmail.com"
    fill_in "Password", with: "password"

    click_on "Log in"

    assert_text "Signed in successfully."
  end
end
