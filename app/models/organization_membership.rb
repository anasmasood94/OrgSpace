class OrganizationMembership < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :organization

  # Validations
  validates :user_id, uniqueness: { scope: :organization_id }
  validates :status, presence: true
  validates :member_type, presence: true
  validate :user_age_restrictions

  # Enums
  enum status: { active: 0, inactive: 1, pending: 2, suspended: 3 }
  enum member_type: { admin: 0, member: 1 }

  # Callbacks
  before_create :set_joined_at

  # Scopes
  scope :active, -> { where(status: :active) }
  scope :pending, -> { where(status: :pending) }
  scope :admin, -> { where(member_type: :admin) }
  scope :member, -> { where(member_type: :member) }

  def admin?
    member_type == 'admin'
  end

  def member?
    member_type == 'member'
  end

  private

  def set_joined_at
    self.joined_at ||= Time.current
  end

  def user_age_restrictions
    if user && user.date_of_birth
      user_age = user.age
      if user_age && user_age < 13
        errors.add(:base, "Users under 13 years old are not allowed.")
      end
      if admin? && user_age && user_age < 18
        errors.add(:base, "A minor (under 18) cannot be assigned as an admin.")
      end
    end
  end
end 