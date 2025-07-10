class Membership < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :organization
  belongs_to :role

  # Validations
  validates :user_id, uniqueness: { scope: :organization_id }
  validates :status, presence: true

  # Enums
  enum status: { active: 0, inactive: 1, pending: 2, suspended: 3 }

  # Callbacks
  before_create :set_joined_at

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :pending, -> { where(status: :pending) }

  # Helper methods
  def activate!
    update!(status: :active, joined_at: Time.current)
  end

  def deactivate!
    update!(status: :inactive)
  end

  private

  def set_joined_at
    self.joined_at ||= Time.current
  end
end