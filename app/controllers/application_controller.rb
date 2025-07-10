class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :check_participation_eligibility
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :check_participation_eligibility, if: :devise_sign_out?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:date_of_birth, :organization_name, :organization_description, :role_type])
    devise_parameter_sanitizer.permit(:account_update, keys: [:date_of_birth])
  end

  private

  def check_participation_eligibility
    return unless user_signed_in?
    return if current_user.can_participate?

    # Allow access to parental consent and pending/denied pages
    if controller_name == 'parental_consents' && %w[new create pending denied].include?(action_name)
      return
    end

    if current_user.requires_parental_consent?
      redirect_to new_parental_consent_path, alert: "Parental consent required for participation."
    else
      redirect_to pending_parental_consent_path, alert: "Parental consent pending. Please wait for approval."
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def devise_sign_out?
    devise_controller? && action_name == 'destroy' && controller_name == 'sessions'
  end
end