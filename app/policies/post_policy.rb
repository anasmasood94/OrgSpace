class PostPolicy < ApplicationPolicy
  def index?
    # This will be handled by the scope
    true
  end

  def show?
    user.admin_of?(record.organization) ||
      (user.member_of?(record.organization) && (user.adult? || record.age_group_id.nil? || record.age_group_id == user.age_group_id))
  end

  def create?
    user.has_permission?('create_post', record.organization)
  end

  def update?
    user.has_permission?('edit_post', record.organization)
  end

  def destroy?
    user.has_permission?('delete_post', record.organization)
  end

  class Scope < Scope
    def resolve
      # For now, return all posts and let the controller filter by organization
      # The age group filtering will be done in the controller
      scope.all
    end
  end
end 