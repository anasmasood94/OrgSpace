class MembershipPolicy < ApplicationPolicy
  def index?
    user.member_of?(record.organization)
  end

  def show?
    user.member_of?(record.organization)
  end

  def create?
    user.role_in(record.organization)&.can_manage_members?
  end

  def update?
    user.role_in(record.organization)&.can_manage_members?
  end

  def destroy?
    user.role_in(record.organization)&.can_manage_members?
  end

  class Scope < Scope
    def resolve
      scope.where(organization: user.organizations)
    end
  end
end