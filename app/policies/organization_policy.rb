class OrganizationPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.member_of?(record) || user.admin?
  end

  def create?
    user.has_permission?('create_organization', record)
  end

  def update?
    user.has_permission?('edit_organization', record)
  end

  def destroy?
    user.has_permission?('delete_organization', record)
  end

  def view_analytics?
    user.has_permission?('view_analytics', record)
  end

  class Scope < Scope
    def resolve
      scope.joins(:organization_memberships).where(organization_memberships: { user: user, status: :active }).distinct
    end
  end
end