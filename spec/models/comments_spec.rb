require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:author) { create(:author) }
  let!(:article) { create(:article, author: author) }

  describe "leaving the comments" do
    context "as a signed-in author" do
      before do
        sign_in author
      end

      it "allows the author to create a comment and sets the commenter automatically" do
        expect {
          post article_comments_path(article), params: { comment: { body: "This is a great article!", status: "public" } }
        }.to change(Comment, :count).by(1)

        expect(response).to redirect_to(article_path(article))
        follow_redirect!
        expect(response.body).to include("This is a great article!")
        expect(response.body).to include(author.full_name)
      end
    end

    context "as an anonymous user" do
      it "does not set the commenter name automatically" do
        post article_comments_path(article), params: { comment: { commenter: "Anonymous", body: "Informative post!", status: "public" } }

        expect(Comment.last.commenter).to eq("Anonymous")
      end
    end
  end
end
