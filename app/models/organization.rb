class Organization < ApplicationRecord
  # Associations
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships
  has_many :organization_roles, dependent: :destroy
  has_many :roles, through: :organization_roles
  has_many :participation_rules, dependent: :destroy
  has_many :posts, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true

  # Helper methods
  def member_count
    organization_memberships.active.count
  end

  def admin_users
    users.joins(:organization_memberships).where(organization_memberships: { member_type: :admin, status: :active })
  end

  def participation_rule_for(age_group)
    participation_rules.find_by(age_group: age_group)
  end
end