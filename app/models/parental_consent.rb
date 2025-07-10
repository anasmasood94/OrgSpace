class ParentalConsent < ApplicationRecord
  belongs_to :user
  
  validates :parent_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :consent_given, inclusion: { in: [true, false] }, allow_nil: true
  
  scope :pending, -> { where(consent_given: nil) }
  scope :approved, -> { where(consent_given: true) }
  scope :denied, -> { where(consent_given: false) }
  
  # Generate secure tokens for approval/denial
  def generate_approval_token
    Digest::SHA256.hexdigest("#{id}-#{parent_email}-approve-#{Rails.application.credentials.secret_key_base}")
  end
  
  def generate_denial_token
    Digest::SHA256.hexdigest("#{id}-#{parent_email}-deny-#{Rails.application.credentials.secret_key_base}")
  end
  
  def valid_approval_token?(token)
    token == generate_approval_token
  end
  
  def valid_denial_token?(token)
    token == generate_denial_token
  end
  
  # Send consent request email
  def send_consent_request(organization = nil)
    ParentalConsentMailer.with(
      parental_consent: self,
      organization: organization
    ).consent_request.deliver_now
  end
  
  # Approve consent
  def approve!
    update!(consent_given: true, consent_date: Time.current)
    ParentalConsentMailer.with(parental_consent: self).consent_approved.deliver_now
  end
  
  # Deny consent
  def deny!
    update!(consent_given: false, consent_date: Time.current)
    ParentalConsentMailer.with(parental_consent: self).consent_denied.deliver_now
  end
end