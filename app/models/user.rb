class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Age validation
  validates :date_of_birth, presence: true
  # validate :age_requirement
  validate :admin_age_requirement, on: :create

  # Associations
  belongs_to :age_group, optional: true
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships
  has_one :parental_consent, dependent: :destroy

  # Callbacks
  after_save :update_minor_status, if: :saved_change_to_date_of_birth?
  after_save :update_age_group, if: :saved_change_to_date_of_birth?

  # Helper methods
  def age
    return unless date_of_birth
    now = Time.zone.now.to_date
    now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
  end

  def minor?
    minor
  end

  def adult?
    !minor?
  end

  def member_of?(organization)
    organization_memberships.active.exists?(organization: organization)
  end

  def admin_of?(organization)
    organization_memberships.active.admin.exists?(organization: organization)
  end

  def admin?
    organization_memberships.active.admin.exists?
  end

  def requires_parental_consent?
    minor? && parental_consent.nil?
  end
  
  def parental_consent_approved?
    parental_consent&.consent_given?
  end
  
  def can_participate?
    adult? || (minor? && parental_consent_approved?)
  end

  def participation_rule_for(organization)
    return nil unless age_group
    organization.participation_rules.find_by(age_group: age_group)
  end

  # Returns an array of Role objects for this user in the given organization
  def roles_in(organization)
    membership = organization_memberships.active.find_by(organization: organization)
    return [] unless membership
    role_names = []
    role_names << "admin-#{organization.id}" if membership.admin?
    role_names << "member-#{organization.id}" if membership.member?
    organization.roles.where(name: role_names)
  end

  # Checks if the user has a given permission in the organization
  def has_permission?(permission, organization)
    roles_in(organization).any? { |role| role.has_permission?(permission) }
  end

  private

  def age_requirement
    return unless date_of_birth
    # Only apply this check if not a Devise registration (signup)
    if !defined?(organization_name) && age && age < 13
      errors.add(:age, "must be at least 13 years!")
    end
  end

  def admin_age_requirement
    # Only check if this is an org-creating signup (i.e., org name present in params)
    if defined?(organization_name) && organization_name.present? && age && age < 18
      errors.add(:base, "You must be at least 18 years old to create an organization.")
    end
  end

  def update_minor_status
    new_minor_status = age && age < 18
    update_column(:minor, new_minor_status) if minor != new_minor_status
  end

  def update_age_group
    return unless age
    new_age_group = AgeGroup.find_by_age(age)
    update_column(:age_group_id, new_age_group&.id) if age_group_id != new_age_group&.id
  end
end