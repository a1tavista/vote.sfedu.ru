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

ActiveRecord::Schema.define(version: 20180305162155) do

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
    t.integer "max_rating", default: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions_stages", id: false, force: :cascade do |t|
    t.bigint "stage_id"
    t.bigint "question_id"
    t.index ["question_id"], name: "index_questions_stages_on_question_id"
    t.index ["stage_id"], name: "index_questions_stages_on_stage_id"
  end

  create_table "semesters", force: :cascade do |t|
    t.integer "year_begin"
    t.integer "year_end"
    t.integer "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "semesters_stages", id: false, force: :cascade do |t|
    t.bigint "semester_id"
    t.bigint "stage_id"
    t.index ["semester_id"], name: "index_semesters_stages_on_semester_id"
    t.index ["stage_id"], name: "index_semesters_stages_on_stage_id"
  end

  create_table "stages", force: :cascade do |t|
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.integer "lower_participants_limit", default: 10, null: false
    t.integer "scale_min", default: 6, null: false
    t.integer "scale_max", default: 10, null: false
    t.integer "lower_truncation_percent", default: 5, null: false
    t.integer "upper_truncation_percent", default: 5, null: false
    t.string "scale_ladder", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "external_id", null: false
    t.string "name"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students_teachers_relations", force: :cascade do |t|
    t.bigint "student_id"
    t.bigint "teacher_id"
    t.bigint "semester_id"
    t.string "disciplines", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["semester_id"], name: "index_students_teachers_relations_on_semester_id"
    t.index ["student_id"], name: "index_students_teachers_relations_on_student_id"
    t.index ["teacher_id"], name: "index_students_teachers_relations_on_teacher_id"
  end

  create_table "survey_answers", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.bigint "survey_question_id", null: false
    t.bigint "survey_option_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_answers_on_survey_id"
    t.index ["survey_option_id"], name: "index_survey_answers_on_survey_option_id"
    t.index ["survey_question_id"], name: "index_survey_answers_on_survey_question_id"
    t.index ["user_id"], name: "index_survey_answers_on_user_id"
  end

  create_table "survey_options", force: :cascade do |t|
    t.bigint "survey_question_id"
    t.string "text"
    t.boolean "custom", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_question_id"], name: "index_survey_options_on_survey_question_id"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.string "text"
    t.boolean "required", default: true, null: false
    t.boolean "multichoice", default: false, null: false
    t.boolean "free_answer", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
  end

  create_table "survey_sharings", force: :cascade do |t|
    t.bigint "survey_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_sharings_on_survey_id"
    t.index ["user_id"], name: "index_survey_sharings_on_user_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "private", default: true, null: false
    t.boolean "anonymous", default: true, null: false
    t.string "title", null: false
    t.string "passcode", null: false
    t.date "active_until", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_surveys_on_user_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "external_id"
    t.string "name"
    t.string "snils"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 0
    t.string "encrypted_snils"
    t.string "stale_external_id"
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
  add_foreign_key "questions_stages", "questions"
  add_foreign_key "questions_stages", "stages"
  add_foreign_key "semesters_stages", "semesters"
  add_foreign_key "semesters_stages", "stages"
  add_foreign_key "students_teachers_relations", "semesters"
  add_foreign_key "students_teachers_relations", "students"
  add_foreign_key "students_teachers_relations", "teachers"
  add_foreign_key "survey_answers", "survey_options"
  add_foreign_key "survey_answers", "survey_questions"
  add_foreign_key "survey_answers", "surveys"
  add_foreign_key "survey_answers", "users"
  add_foreign_key "survey_questions", "surveys"
  add_foreign_key "survey_sharings", "surveys"
  add_foreign_key "survey_sharings", "users"
  add_foreign_key "surveys", "users"
end
