class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :age_group, null: true, foreign_key: true
    add_column :users, :minor, :boolean, default: false
  end
end
