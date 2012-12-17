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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121217034004) do

  create_table "professors", :force => true do |t|
    t.string "title"
  end

  create_table "quarters", :force => true do |t|
    t.string "title"
  end

  create_table "sections", :force => true do |t|
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
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "subjects", :force => true do |t|
    t.string "title"
  end

  create_table "titles", :force => true do |t|
    t.string "title"
  end

  create_table "years", :force => true do |t|
    t.integer "title"
  end

end
