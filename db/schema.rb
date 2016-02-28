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

ActiveRecord::Schema.define(version: 20160224041823) do

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
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
