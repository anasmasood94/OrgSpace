class CreateAgeGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :age_groups do |t|
      t.string :name
      t.text :description
      t.integer :min_age
      t.integer :max_age

      t.timestamps
    end
  end
end
