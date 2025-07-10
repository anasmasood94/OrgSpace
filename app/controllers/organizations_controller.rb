class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  def index
    @organizations = policy_scope(Organization)

    if current_user.organization_memberships.where(status: [:pending, :suspended]).exists?
      flash[:alert] = "Your membership is currently pending or suspend that's why you cannot participate in organizataion activities. Please contact your organization admin for further details."
    end
  end

  def show
    authorize @organization
    @members = @organization.organization_memberships.includes(:user)
    @analytics = OrganizationAnalytics.new(@organization)
  end

  def new
    @organization = Organization.new
    authorize @organization
  end

  def create
    @organization = Organization.new(organization_params)
    authorize @organization
    
    if @organization.save
      # Create default roles for the organization
      create_default_roles(@organization)
      
      # Add creator as admin
      @organization.organization_memberships.create!(
        user: current_user,
        member_type: :admin,
        status: :active
      )
      
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @organization
  end

  def update
    authorize @organization
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @organization
    @organization.destroy
    redirect_to organizations_url, notice: 'Organization was successfully destroyed.'
  end

  def analytics
    @organization = Organization.find(params[:id])
    authorize @organization, :view_analytics?
    @analytics = OrganizationAnalytics.new(@organization)
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :description, :domain, :status)
  end

  def create_default_roles(organization)
    # Create unique admin role for this organization
    admin_role = Role.create!(
      name: "admin-#{organization.id}",
      permissions: ['manage_organization', 'manage_members', 'view_analytics', 'create_post', 'edit_post', 'edit_organization']
    )

    # Create unique member role for this organization
    member_role = Role.create!(
      name: "member-#{organization.id}",
      permissions: ['view_analytics']
    )

    # Create organization roles
    organization.organization_roles.create!(role: admin_role)
    organization.organization_roles.create!(role: member_role)
  end
end