require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  let(:author) { FactoryBot.create(:author) }
  let(:other_author) { FactoryBot.create(:author) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      author = FactoryBot.create(:author)
      get :show, params: { id: author.id }
      expect(response).to be_successful
    end
  end
  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      sign_in author
      get :edit, params: { id: author.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    context "when author is logged in" do
      before do
        sign_in author
      end

      context "when trying to edit other author" do
        let(:other_author) { FactoryBot.create(:author) }

        it "does not allow access to edit other author's details" do
          get :edit, params: { id: other_author.to_param }
          expect(response).to redirect_to(authors_path)
          expect(flash[:alert]).to eq("You cannot edit this author.")
        end
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { first_name: "New First Name", last_name: "New Last Name" }
      }

      it "updates the requested author" do
        sign_in author
        put :update, params: { id: author.to_param, author: new_attributes }
        author.reload
        expect(author.first_name).to eq("New First Name")
        expect(author.last_name).to eq("New Last Name")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested author" do
      sign_in author
      expect {
        delete :destroy, params: { id: author.to_param }
      }.to change(Author, :count).by(-1)
    end
  end

end
