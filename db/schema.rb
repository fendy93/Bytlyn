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

ActiveRecord::Schema.define(version: 20151125055358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "email",           null: false
    t.boolean  "rest",            null: false
    t.string   "name",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
  end

  create_table "carts", force: :cascade do |t|
    t.integer  "cust_id",    null: false
    t.integer  "rest_id",    null: false
    t.integer  "version",    null: false
    t.integer  "menu_id",    null: false
    t.integer  "qty",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "user_id",             null: false
    t.integer  "phone_number",        null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "deliveries", force: :cascade do |t|
    t.string   "phone",      null: false
    t.integer  "rest_id",    null: false
    t.integer  "version",    null: false
    t.integer  "user_id",    null: false
    t.string   "address",    null: false
    t.float    "total",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
  end

  create_table "favorites", force: :cascade do |t|
    t.string "cust_id", null: false
    t.string "rest_id", null: false
  end

  create_table "hours", force: :cascade do |t|
    t.integer  "rest_id",    null: false
    t.integer  "day_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time     "open"
    t.time     "close"
  end

  create_table "menus", force: :cascade do |t|
    t.integer  "rest_id",             null: false
    t.string   "name",                null: false
    t.string   "description"
    t.float    "price",               null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "rating"
    t.integer  "customer_id"
    t.integer  "restaurant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "restaurants", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.string   "address"
    t.string   "hours"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "rating"
    t.integer  "price"
    t.string   "rest_type"
    t.text     "description"
    t.string   "city"
    t.string   "zip"
    t.decimal  "lat"
    t.decimal  "lon"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name",                                null: false
    t.boolean  "rest",                                null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "braintree_customer_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.integer  "cust_id",    null: false
    t.integer  "rest_id",    null: false
    t.integer  "count",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "waitlists", force: :cascade do |t|
    t.integer  "rest_id",    null: false
    t.integer  "cust_id",    null: false
    t.integer  "people",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.integer  "status",     null: false
  end

end
