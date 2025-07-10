class CreateRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :permissions
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
