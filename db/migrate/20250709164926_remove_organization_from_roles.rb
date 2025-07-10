class RemoveOrganizationFromRoles < ActiveRecord::Migration[7.2]
  def change
    remove_reference :roles, :organization, null: true, foreign_key: true
  end
end
