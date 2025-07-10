class CreateParentalConsents < ActiveRecord::Migration[7.2]
  def change
    create_table :parental_consents do |t|
      t.references :user, null: false, foreign_key: true
      t.string :parent_email
      t.boolean :consent_given
      t.datetime :consent_date

      t.timestamps
    end
  end
end
