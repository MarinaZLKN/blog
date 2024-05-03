class Article < ApplicationRecord
  belongs_to :author
  include Visible

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates :author_id, presence: true

end
