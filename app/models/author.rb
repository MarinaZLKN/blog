class Author < ApplicationRecord
  has_many :articles
  validates :email, presence: true,  uniqueness: { message: "already exists" }
end
