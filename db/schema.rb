# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160812084949) do

  create_table "contact_organization_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "contact_id"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["contact_id"], name: "index_contact_organization_links_on_contact_id", using: :btree
    t.index ["organization_id"], name: "index_contact_organization_links_on_organization_id", using: :btree
  end

  create_table "contacts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "lab_id"
    t.string   "last_name",        default: ""
    t.string   "first_name",       default: ""
    t.string   "email",            default: ""
    t.string   "address_street",   default: ""
    t.string   "address_zip_code", default: ""
    t.string   "address_city",     default: ""
    t.string   "address_country",  default: ""
    t.string   "phone",            default: ""
    t.boolean  "active"
    t.string   "twitter_url",      default: ""
    t.string   "linkedin_url",     default: ""
    t.string   "facebook_url",     default: ""
    t.string   "website_url",      default: ""
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["lab_id"], name: "index_contacts_on_lab_id", using: :btree
  end

  create_table "fields", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_fields_on_parent_id", using: :btree
  end

  create_table "lab_user_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "lab_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lab_id"], name: "index_lab_user_links_on_lab_id", using: :btree
    t.index ["user_id"], name: "index_lab_user_links_on_user_id", using: :btree
  end

  create_table "labs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer  "lab_id"
    t.string   "name",                      default: ""
    t.string   "status",                    default: ""
    t.text     "description", limit: 65535
    t.string   "website_url",               default: ""
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["lab_id"], name: "index_organizations_on_lab_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string   "name"
    t.boolean  "admin",                  default: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "contact_organization_links", "contacts"
  add_foreign_key "contact_organization_links", "organizations"
  add_foreign_key "contacts", "labs"
  add_foreign_key "fields", "fields", column: "parent_id"
  add_foreign_key "lab_user_links", "labs"
  add_foreign_key "lab_user_links", "users"
  add_foreign_key "organizations", "labs"
end
