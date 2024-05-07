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
    assert_current_path(new_article_path)
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

  test "logging in the auhtor, creating, editing and deleting the article, then
   logging out - also check that unauthorized user cannot edit or delete the author" do
    author=Author.create!(
      first_name: "Marina",
      last_name: "Another",
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
    assert_current_path(new_article_path)

    fill_in "Title", with: "Newest article"
    fill_in "Body", with: "New article text for testing"

    click_on "Save"
    assert_current_path(article_path(Article.last))


    click_on "Edit"
    fill_in "Title", with: "New article - edited"
    fill_in "Body", with: "New article text for testing - edited"

    click_on "Save"
    assert_text "Article successfully updated."
    assert_current_path(article_path(Article.last))

    click_on "Delete"
    sleep 2
    page.driver.browser.switch_to.alert.accept
    assert_text "Article successfully deleted!"
    assert_current_path(root_path)

    click_on "Log Out"
    assert_text "Signed out successfully."
    sleep 1

    visit authors_path
    assert_current_path(authors_path)
    sleep 1

    author_card = find('div.card', text: author.full_name)
    author_card.click
    click_on "Edit"

    assert_text "You need to sign in or sign up before continuing."
    visit authors_path
    assert_current_path(authors_path)
    sleep 1

    author_card = find('div.card', text: author.full_name)
    author_card.click
    click_on "Delete"
    sleep 2
    page.driver.browser.switch_to.alert.accept

    assert_text "You need to sign in or sign up before continuing."
  end

  test "logging in and editing and deleting the author" do
    author =Author.create!(
      first_name: "Marina",
      last_name: "New",
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

    visit authors_path
    assert_current_path(authors_path)
    assert_text 'Authors'

    author_card = find('div.card', text: author.full_name)
    author_card.click
    assert_text author.full_name
    assert_current_path(author_path(author))

    click_on "Edit"
    fill_in "First name", with: "Marina - edited"
    fill_in "Last name", with: "Zhilkina - edited"

    click_on "Save"
    assert_text "Author was successfully updated."

    click_on "Delete"
    sleep 2
    page.driver.browser.switch_to.alert.accept
    assert_text "Author was successfully deleted."
    assert_current_path(authors_path)
  end

  test "displaying list of authors" do
    author1 = Author.create!(first_name: "Johnny", last_name: "Cash", email: "johnny@gmail.com", password: "password1")
    author2 = Author.create!(first_name: "Amy", last_name: "Winehouse", email: "amy@gmail.com", password: "password2")

    visit authors_path

    assert_text author1.full_name
    assert_text author2.full_name
  end

  test "displaying author profile page" do
    author = Author.create!(first_name: "Johnny", last_name: "Cash", email: "johnny@gmail.com", password: "password1")

    visit author_path(author)

    assert_text author.full_name
    assert_text author.email
  end

  test "handling invalid registration data" do
    visit root_path
    click_on "New article"
    click_on "Sign up"

    fill_in "First name", with: ""
    fill_in "Last name", with: ""
    fill_in "Email", with: "email@gmail.com"
    fill_in "Password", with: "short"
    fill_in "Password confirmation", with: "password"

    click_on "Sign up"
    sleep 2

    assert_text "First name can't be blank"
    assert_text "Last name can't be blank"
    assert_text "Password is too short (minimum is 6 characters)"
    assert_text "Password confirmation doesn't match Password"

  end
  test "authenticated author cannot edit or delete other authors" do
    Author.create!(
      first_name: "Author",
      last_name: "Popular",
      email: "popular@mail.com",
      password: "password"
    )
    author2 = Author.create!(
      first_name: "Painter",
      last_name: "Unpopular",
      email: "unpopulare@mail.com",
      password: "password2"
    )

    visit root_path
    click_on "New article"
    assert_text "You need to sign in or sign up before continuing."
    fill_in "Email", with: "popular@mail.com"
    fill_in "Password", with: "password"

    click_on "Log in"
    assert_text "Signed in successfully."

    visit authors_path
    assert_current_path(authors_path)
    assert_text 'Authors'

    author_card = find('div.card', text: author2.full_name)
    author_card.click

    assert_current_path(author_path(author2))

    click_on "Edit"
    assert_text "You cannot edit this author."

    author_card = find('div.card', text: author2.full_name)
    author_card.click

    assert_current_path(author_path(author2))

    click_on "Delete"
    sleep 2
    page.driver.browser.switch_to.alert.accept
    assert_text "You cannot delete this author."
    assert_current_path(authors_path)

  end

end
