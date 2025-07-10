class ParentalConsentsController < ApplicationController
  skip_before_action :check_participation_eligibility, only: [:new, :create, :pending, :denied]
  before_action :authenticate_user!
  before_action :ensure_minor

  def new
    @parental_consent = current_user.parental_consent || current_user.build_parental_consent
  end

  def create
    @parental_consent = current_user.parental_consent || current_user.build_parental_consent
    @parental_consent.assign_attributes(parental_consent_params)

    if @parental_consent.save
      @parental_consent.send_consent_request
      redirect_to pending_parental_consent_path, notice: 'Parental consent request sent. Please wait for approval.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def pending
    # Just renders the pending view
  end

  def denied
    # Renders the denied view
  end

  private

  def ensure_minor
    unless current_user.minor?
      redirect_to root_path, alert: 'Parental consent is only required for minors.'
    end
  end

  def parental_consent_params
    params.require(:parental_consent).permit(:parent_email)
  end
end