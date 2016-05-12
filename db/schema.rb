# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160511205229) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "booked_hours", force: :cascade do |t|
    t.integer  "doctor_user_id"
    t.integer  "patient_user_id"
    t.string   "title"
    t.datetime "from"
    t.datetime "to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",          default: 0
  end

  create_table "doctor_infos", force: :cascade do |t|
    t.integer  "doctor_user_id"
    t.string   "website"
    t.integer  "speciality_id"
    t.boolean  "house_calls",    default: false
    t.text     "days",           default: [],                 array: true
    t.time     "hours_from"
    t.time     "hours_to"
    t.text     "bio"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "feedback_count", default: 0
    t.float    "feedback_score"
  end

  create_table "identities", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "token"
    t.datetime "expires_at"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "refresh_token"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "open_hours", force: :cascade do |t|
    t.integer  "doctor_user_id"
    t.string   "title"
    t.time     "to"
    t.time     "from"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "appointment_id"
    t.text     "feedback"
    t.float    "avg_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["appointment_id"], name: "index_reviews_on_appointment_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "slug",          default: "", null: false
    t.integer  "speciality_id",              null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "specialities", force: :cascade do |t|
    t.string   "name",               default: "", null: false
    t.string   "slug",               default: "", null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "specialities", ["slug"], name: "index_specialities_on_slug", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthdate"
    t.string   "phone"
    t.string   "bizname"
    t.string   "type"
    t.string   "provider"
    t.string   "uid"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "address"
    t.string   "city"
    t.string   "zipcode"
    t.string   "state"
    t.string   "country"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  add_foreign_key "booked_hours", "users", column: "doctor_user_id"
  add_foreign_key "booked_hours", "users", column: "patient_user_id"
  add_foreign_key "doctor_infos", "users", column: "doctor_user_id"
  add_foreign_key "open_hours", "users", column: "doctor_user_id"
  add_foreign_key "services", "specialities"
end
