class Role < ApplicationRecord
  # Associations
  has_many :organization_roles, dependent: :destroy
  has_many :organizations, through: :organization_roles

  # Validations
  validates :name, presence: true
  validates :permissions, presence: true

  # Store permissions as JSON
  serialize :permissions, coder: JSON

  # Scopes
  scope :admin_roles, -> { where(name: 'admin') }
  scope :member_roles, -> { where(name: 'member') }

  # Helper methods
  def has_permission?(permission)
    permissions.include?(permission.to_s)
  end

  def can_manage_members?
    has_permission?('manage_members')
  end

  def can_manage_organization?
    has_permission?('manage_organization')
  end
end