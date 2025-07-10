class MembershipsController < ApplicationController
  before_action :set_organization
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_action :ensure_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
    @memberships = policy_scope(OrganizationMembership).where(organization: @organization)
  end

  def show
    authorize @membership
  end

  def new
    @membership = @organization.organization_memberships.build
    authorize @membership
  end

  def create
    # Create new user with provided information
    @user = User.new(user_params)

    if @user.save
      # Create organization membership
      @membership = @organization.organization_memberships.build(membership_params)
      @membership.user = @user
      authorize @membership

      if @membership.save
        redirect_to organization_memberships_path(@organization), notice: 'Member was successfully added.'
      else
        @user.destroy # Clean up the user if membership fails
        render :new, status: :unprocessable_entity
      end
    else
      @membership = @organization.organization_memberships.build(membership_params)
      @membership.errors.merge!(@user.errors)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @membership
    @membership.user.reload
  end

  def update
    authorize @membership
    user_updated = @membership.user.update(user_update_params)
    membership_updated = @membership.update(membership_params)
    if user_updated && membership_updated
      redirect_to organization_memberships_path(@organization), notice: 'Membership was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @membership
    if @membership.user == current_user
      redirect_to organization_memberships_path(@organization), alert: "You cannot remove yourself from the organization."
      return
    end
    if @membership.admin?
      redirect_to organization_memberships_path(@organization), alert: "You cannot remove an admin from the organization."
      return
    end
    @membership.destroy
    redirect_to organization_memberships_path(@organization), notice: 'Member was successfully removed.'
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def set_membership
    @membership = @organization.organization_memberships.find(params[:id])
  end

  def ensure_admin
    unless current_user.admin_of?(@organization)
      redirect_to organization_path(@organization), alert: 'Only organization admins can manage members.'
    end
  end

  def membership_params
    params.require(:organization_membership).permit(:member_type, :status)
  end

  def user_params
    params.require(:organization_membership).permit(:email, :password, :password_confirmation, :date_of_birth)
  end

  def user_update_params
    params.require(:organization_membership).permit(:email, :date_of_birth)
  end
end
