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

ActiveRecord::Schema.define(version: 20160417014623) do

  create_table "ports", force: :cascade do |t|
    t.integer  "int_idx"
    t.string   "port_name"
    t.integer  "input"
    t.integer  "output"
    t.string   "mac_address"
    t.string   "status"
    t.integer  "switch_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "ports", ["switch_id"], name: "index_ports_on_switch_id"

  create_table "switches", force: :cascade do |t|
    t.string   "name"
    t.string   "ipaddress"
    t.string   "user_name"
    t.string   "switch_password"
    t.string   "enable_password"
    t.string   "community"
    t.string   "serial"
    t.datetime "contacted_at"
    t.decimal  "latitude",        precision: 15, scale: 10, default: 0.0
    t.decimal  "longitude",       precision: 15, scale: 10, default: 0.0
    t.integer  "user_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "switches", ["user_id"], name: "index_switches_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "full_name",              default: "", null: false
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
