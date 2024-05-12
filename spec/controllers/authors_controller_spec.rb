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

end
