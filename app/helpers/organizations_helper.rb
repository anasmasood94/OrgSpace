module OrganizationsHelper
  # Returns organizations where the current user is an admin
  # @param user [User] the user to check admin organizations for
  # @return [ActiveRecord::Relation] organizations where the user is an admin
  def admin_organizations_for(user)
    user.organizations.joins(:organization_memberships)
      .where(organization_memberships: { member_type: :admin, status: :active })
      .distinct
  end

  # Returns the user's membership status for a given organization (as a symbol)
  # @param user [User] the user to check membership status for
  # @param organization [Organization] the organization to check membership in
  # @return [Symbol] the membership status (e.g., :active, :pending, :suspended)
  def membership_status_for(user, organization)
    user.organization_memberships.find_by(organization: organization)&.status&.to_sym
  end
end
