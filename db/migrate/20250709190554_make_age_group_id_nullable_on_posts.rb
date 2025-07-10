class MakeAgeGroupIdNullableOnPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :posts, :age_group_id, true
  end
end
