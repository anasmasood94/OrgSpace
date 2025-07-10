class CreateOrganizationRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :organization_roles do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
