class ConsentApprovalsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_participation_eligibility
  
  def approve
    @parental_consent = ParentalConsent.find(params[:id])
    
    if @parental_consent.valid_approval_token?(params[:token])
      @parental_consent.approve!
      redirect_to root_path, notice: 'Parental consent has been approved. The user will be notified by email.'
    else
      redirect_to root_path, alert: 'Invalid or expired approval link.'
    end
  end
  
  def deny
    @parental_consent = ParentalConsent.find(params[:id])
    
    if @parental_consent.valid_denial_token?(params[:token])
      @parental_consent.deny!
      redirect_to parental_consent_denied_path
    else
      redirect_to root_path, alert: 'Invalid or expired denial link.'
    end
  end
end