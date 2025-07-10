class CreateOrganizations < ActiveRecord::Migration[7.2]
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :description
      t.string :domain
      t.integer :status

      t.timestamps
    end
  end
end
