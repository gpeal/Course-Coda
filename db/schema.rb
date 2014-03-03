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

ActiveRecord::Schema.define(version: 20140301230650) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feedbacks", force: true do |t|
    t.text     "feedback"
    t.integer  "section_id"
    t.boolean  "sentiment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professors", force: true do |t|
    t.string "title"
  end

  create_table "quarters", force: true do |t|
    t.string "title"
  end

  create_table "sections", force: true do |t|
    t.integer  "subject_id"
    t.integer  "title_id"
    t.integer  "professor_id"
    t.integer  "quarter_id"
    t.integer  "year_id"
    t.float    "instruction"
    t.string   "instruction_breakdown"
    t.integer  "instruction_responses"
    t.integer  "instruction_enroll_count"
    t.float    "course"
    t.string   "course_breakdown"
    t.integer  "course_responses"
    t.integer  "course_enroll_count"
    t.float    "learned"
    t.string   "learned_breakdown"
    t.integer  "learned_responses"
    t.integer  "learned_enroll_count"
    t.float    "challenged"
    t.string   "challenged_breakdown"
    t.integer  "challenged_responses"
    t.integer  "challenged_enroll_count"
    t.float    "stimulated"
    t.string   "stimulated_breakdown"
    t.integer  "stimulated_responses"
    t.integer  "stimulated_enroll_count"
    t.string   "time_breakdown"
    t.text     "feedback"
    t.string   "school_breakdown"
    t.string   "class_breakdown"
    t.string   "reasons_breakdown"
    t.string   "interest_breakdown"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "signatures", force: true do |t|
    t.string   "email"
    t.string   "university"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", force: true do |t|
    t.string "title"
  end

  create_table "titles", force: true do |t|
    t.string "title"
  end

  create_table "users", force: true do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "years", force: true do |t|
    t.integer "title"
  end

end
