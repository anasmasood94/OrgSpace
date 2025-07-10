# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_07_09_221955) do
  create_table "age_groups", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "min_age"
    t.integer "max_age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "organization_id", null: false
    t.integer "role_id", null: false
    t.integer "status"
    t.datetime "joined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["role_id"], name: "index_memberships_on_role_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "organization_memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "organization_id", null: false
    t.integer "status"
    t.integer "member_type", default: 1
    t.datetime "joined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_memberships_on_organization_id"
    t.index ["user_id"], name: "index_organization_memberships_on_user_id"
  end

  create_table "organization_roles", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.integer "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_roles_on_organization_id"
    t.index ["role_id"], name: "index_organization_roles_on_role_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "domain"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parental_consents", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "parent_email"
    t.boolean "consent_given"
    t.datetime "consent_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_parental_consents_on_user_id"
  end

  create_table "participation_rules", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.integer "age_group_id", null: false
    t.boolean "can_join", default: true
    t.boolean "can_view_content", default: true
    t.boolean "can_participate_in_activities", default: true
    t.boolean "requires_parental_consent", default: false
    t.text "content_restrictions"
    t.text "activity_restrictions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["age_group_id"], name: "index_participation_rules_on_age_group_id"
    t.index ["organization_id", "age_group_id"], name: "index_participation_rules_on_organization_id_and_age_group_id", unique: true
    t.index ["organization_id"], name: "index_participation_rules_on_organization_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "organization_id", null: false
    t.integer "user_id", null: false
    t.integer "age_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "views_count", default: 0, null: false
    t.index ["age_group_id"], name: "index_posts_on_age_group_id"
    t.index ["organization_id"], name: "index_posts_on_organization_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text "permissions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_of_birth"
    t.integer "age_group_id"
    t.boolean "minor", default: false
    t.index ["age_group_id"], name: "index_users_on_age_group_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "roles"
  add_foreign_key "memberships", "users"
  add_foreign_key "organization_memberships", "organizations"
  add_foreign_key "organization_memberships", "users"
  add_foreign_key "organization_roles", "organizations"
  add_foreign_key "organization_roles", "roles"
  add_foreign_key "parental_consents", "users"
  add_foreign_key "participation_rules", "age_groups"
  add_foreign_key "participation_rules", "organizations"
  add_foreign_key "posts", "age_groups"
  add_foreign_key "posts", "organizations"
  add_foreign_key "posts", "users"
  add_foreign_key "users", "age_groups"
end
