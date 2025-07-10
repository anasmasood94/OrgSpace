class CreateParticipationRules < ActiveRecord::Migration[7.2]
  def change
    create_table :participation_rules do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :age_group, null: false, foreign_key: true
      t.boolean :can_join, default: true
      t.boolean :can_view_content, default: true
      t.boolean :can_participate_in_activities, default: true
      t.boolean :requires_parental_consent, default: false
      t.text :content_restrictions
      t.text :activity_restrictions

      t.timestamps
    end
    
    add_index :participation_rules, [:organization_id, :age_group_id], unique: true
  end
end
