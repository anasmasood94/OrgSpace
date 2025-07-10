class ParticipationRule < ApplicationRecord
  # Associations
  belongs_to :organization
  belongs_to :age_group

  # Validations
  validates :organization_id, uniqueness: { scope: :age_group_id }
  validates :can_join, inclusion: { in: [true, false] }
  validates :can_view_content, inclusion: { in: [true, false] }
  validates :can_participate_in_activities, inclusion: { in: [true, false] }
  validates :requires_parental_consent, inclusion: { in: [true, false] }

  # Scopes
  scope :for_minors, -> { joins(:age_group).where(age_groups: { name: 'Minors' }) }
  scope :for_adults, -> { joins(:age_group).where(age_groups: { name: 'Adults' }) }

  # Instance methods
  def allows_joining?
    can_join
  end

  def allows_content_viewing?
    can_view_content
  end

  def allows_activity_participation?
    can_participate_in_activities
  end
end 