class RolePolicy < ApplicationPolicy
  def index?
    user.member_of?(record.organization)
  end

  def show?
    user.member_of?(record.organization)
  end

  def create?
    user.role_in(record.organization)&.can_manage_organization?
  end

  def update?
    user.role_in(record.organization)&.can_manage_organization?
  end

  def destroy?
    user.role_in(record.organization)&.can_manage_organization?
  end

  class Scope < Scope
    def resolve
      scope.where(organization: user.organizations)
    end
  end
end