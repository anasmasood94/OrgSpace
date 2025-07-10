class AgeGroup < ApplicationRecord
  # Associations
  has_many :users, dependent: :nullify
  has_many :participation_rules, dependent: :destroy
  has_many :posts, dependent: :nullify

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :min_age, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_age, numericality: { only_integer: true, greater_than: :min_age }, allow_nil: true

  # Scopes
  scope :minors, -> { where(name: 'Minors') }
  scope :adults, -> { where(name: 'Adults') }

  # Class methods
  def self.find_by_age(age)
    where("min_age <= ? AND (max_age IS NULL OR max_age >= ?)", age, age).first
  end

  def minor_group?
    name == 'Minors'
  end
end 