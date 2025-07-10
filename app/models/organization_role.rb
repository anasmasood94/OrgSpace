class OrganizationRole < ApplicationRecord
  # Associations
  belongs_to :organization
  belongs_to :role

  # Validations
  validates :organization_id, uniqueness: { scope: :role_id }

  # Scopes
  scope :admin_roles, -> { joins(:role).where(roles: { name: 'admin' }) }
  scope :member_roles, -> { joins(:role).where(roles: { name: 'member' }) }
end 