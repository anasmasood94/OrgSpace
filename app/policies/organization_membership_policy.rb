class OrganizationMembershipPolicy < ApplicationPolicy
  def new?
    user.admin_of?(record.organization)
  end

  def create?
    user.admin_of?(record.organization)
  end

  def edit?
    user.admin_of?(record.organization)
  end

  def update?
    user.admin_of?(record.organization)
  end

  def destroy?
    user.admin_of?(record.organization)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end 