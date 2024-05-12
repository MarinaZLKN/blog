require 'rails_helper'


RSpec.describe Author, type: :model do
  let!(:user) { FactoryBot.create(:author, email: 'test@gmail.com') }


  describe Author do
    it 'author can have multiple articles' do
      author = FactoryBot.create(:author)

      article1 = FactoryBot.create(:article, author: author)
      article2 = FactoryBot.create(:article, author: author)

      expect(author.articles).to include(article1, article2)
    end

    it 'should validate that author cannot be created if email has already been used' do
      new_user = FactoryBot.build(:author, email: 'test@gmail.com')
      new_user.valid?
      expect(new_user.errors[:email]).to include('has already been taken')
    end

  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { should have_many(:articles).dependent(:destroy) }
    context 'when an author is deleted' do
      let(:author) { FactoryBot.create(:author) }
      let!(:article) { FactoryBot.create(:article, author: author) }

      it 'deletes associated articles' do
        expect { author.destroy }.to change { Article.count }.by(-1)
      end
    end
  end

  describe "#full_name" do
    it "returns the full name of the author" do
      author = FactoryBot.build(:author, first_name: 'Marina', last_name: 'Author')
      expect(author.full_name).to eq('Marina Author')
    end
  end
end
