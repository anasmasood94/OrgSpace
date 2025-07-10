class Post < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :age_group, optional: true

  validates :title, presence: true
  validates :content, presence: true
  validates :organization, presence: true
  validates :user, presence: true
end
