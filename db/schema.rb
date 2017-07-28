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

ActiveRecord::Schema.define(version: 20170727215738) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id"
    t.bigint "stage_id"
    t.bigint "teacher_id"
    t.integer "ratings", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["ratings"], name: "index_answers_on_ratings", using: :gin
    t.index ["stage_id"], name: "index_answers_on_stage_id"
    t.index ["teacher_id"], name: "index_answers_on_teacher_id"
  end

  create_table "faculties", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grade_books", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "faculty_id"
    t.string "major", null: false
    t.string "external_id", null: false
    t.integer "grade_num", null: false
    t.string "group_num", null: false
    t.integer "time_type", default: 0, null: false
    t.integer "grade_level", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faculty_id"], name: "index_grade_books_on_faculty_id"
    t.index ["student_id"], name: "index_grade_books_on_student_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "stage_id"
    t.bigint "student_id"
    t.bigint "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_id"], name: "index_participations_on_stage_id"
    t.index ["student_id"], name: "index_participations_on_student_id"
    t.index ["teacher_id"], name: "index_participations_on_teacher_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "text", null: false
    t.integer "min_evaluation", default: 1, null: false
    t.integer "max_evaluation", default: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stages", force: :cascade do |t|
    t.integer "semester"
    t.string "year_id"
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stages_questions", id: false, force: :cascade do |t|
    t.bigint "stage_id"
    t.bigint "question_id"
    t.index ["question_id"], name: "index_stages_questions_on_question_id"
    t.index ["stage_id"], name: "index_stages_questions_on_stage_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "external_id", null: false
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.string "external_id", null: false
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "identity_url", null: false
    t.string "nickname", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "role", default: 0, null: false
    t.string "kind_type"
    t.bigint "kind_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["identity_url"], name: "index_users_on_identity_url", unique: true
    t.index ["kind_type", "kind_id"], name: "index_users_on_kind_type_and_kind_id"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "stages"
  add_foreign_key "answers", "teachers"
  add_foreign_key "grade_books", "faculties"
  add_foreign_key "grade_books", "students"
  add_foreign_key "participations", "stages"
  add_foreign_key "participations", "students"
  add_foreign_key "participations", "teachers"
  add_foreign_key "stages_questions", "questions"
  add_foreign_key "stages_questions", "stages"
end
