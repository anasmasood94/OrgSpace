class ParentalConsentMailer < ApplicationMailer
  def consent_request
    @parental_consent = params[:parental_consent]
    @user = @parental_consent.user
    @organization = params[:organization]
    
    mail(
      to: @parental_consent.parent_email,
      subject: "Parental Consent Required for #{@user.email}"
    )
  end

  def consent_approved
    @parental_consent = params[:parental_consent]
    @user = @parental_consent.user
    
    mail(
      to: @user.email,
      subject: "Parental Consent Approved"
    )
  end

  def consent_denied
    @parental_consent = params[:parental_consent]
    @user = @parental_consent.user
    
    mail(
      to: @user.email,
      subject: "Parental Consent Denied"
    )
  end
end