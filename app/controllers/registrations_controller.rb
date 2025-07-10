class RegistrationsController < Devise::RegistrationsController
  def create
    ActiveRecord::Base.transaction do
        org_name = params[:user][:organization_name]
        org_desc = params[:user][:organization_description]
        role_type = params[:user][:role_type].presence || 'admin'
        
        # Create organization first if organization name is provided
        organization = nil
        if org_name.present?
            organization = Organization.new(name: org_name, description: org_desc)
            unless organization.save
                # If organization creation fails, add errors to user params
                user_params = sign_up_params
                user_params[:organization_errors] = organization.errors.full_messages
                params[:user] = user_params
            end
        end
        
        # Call super to create the user
        super do |user|
            # Age validation for organization creation
            if org_name.present? && user.age && user.age < 18
                user.errors.add(:base, "You must be at least 18 years old to create an organization.")
                clean_up_passwords(user)
                set_minimum_password_length
                respond_with user and return
            end
            
            if user.persisted? && organization&.persisted?
                # Create unique roles for this organization
                admin_role = Role.create!(
                    name: "admin-#{organization.id}",
                    permissions: ['manage_organization', 'manage_members', 'view_analytics', 'create_post', 'edit_post', 'edit_organization']
                )
                member_role = Role.create!(
                    name: "member-#{organization.id}",
                    permissions: ['view_analytics']
                )
                organization.organization_roles.create!(role: admin_role)
                organization.organization_roles.create!(role: member_role)

                member_type = role_type == 'admin' ? :admin : :member
                user.organization_memberships.create!(
                    organization: organization, 
                    member_type: member_type, 
                    status: :active
                )
            end
        end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :date_of_birth)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :date_of_birth)
  end
end