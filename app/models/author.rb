class Author < ApplicationRecord
  has_many :articles
  validates :email, presence: true,  uniqueness: { message: "already exists" }

  def full_name
    "#{first_name} #{last_name}"
  end
end
