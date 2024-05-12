require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:author) { FactoryBot.create(:author) }
  #let(:other_author) { FactoryBot.create(:other_author) }
  let(:article) { FactoryBot.create(:article, author: author) }
  let(:other_article) { FactoryBot.create(:article, author:author) }

  describe "when author is logged in" do
    before do
      sign_in author
    end

    it "allows author to create an article" do
      post :create, params: { article: FactoryBot.attributes_for(:article) }
      expect(response).to redirect_to(assigns(:article))
    end

    it "allows author to edit their own article" do
      patch :update, params: { id: article.id, article: { title: "Updated Title" } }
      expect(response).to redirect_to(article)
    end

    it "allows author to delete their own article" do
      delete :destroy, params: { id: article.id }
      expect(response).to redirect_to(root_path)
      expect(Article.exists?(article.id)).to be_falsey
    end

    # it "does not allow access to edit an article that does not belong to the author" do
    #   patch :update, params: { id: other_article.id, article: { title: "Updated Title" } }
    #   expect(response).to redirect_to(article_path)
    #   expect(flash[:alert]).to eq("You can edit only your own articles. :)")
    # end

    # it "does not allow to delete an article that does not belong to the author" do
    #   delete :destroy, params: { id: other_article.id }
    #   expect(flash[:alert]).to eq("You can delete only articles that belong to you.")
    # end
  end

  describe "when user is not logged in" do
    it "does not allow access to edit an article" do
      patch :update, params: { id: article.id, article: { title: "Updated Title" } }
      expect(response).to redirect_to(article_path)
    end

    it "does not allow access to delete an article" do
      delete :destroy, params: { id: article.id }
      expect(response).to redirect_to(article_path)
    end
  end
end
