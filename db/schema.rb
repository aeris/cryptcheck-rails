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

ActiveRecord::Schema[7.0].define(version: 2022_06_26_133648) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "analyses", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "service", null: false
    t.string "host", null: false
    t.boolean "pending", default: true, null: false
    t.jsonb "result"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.jsonb "args"
    t.datetime "refresh_at", precision: nil
    t.index ["service", "host", "args"], name: "index_analyses_on_service_and_host_and_args", unique: true
  end

  create_table "stats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.jsonb "data"
    t.index ["name", "date"], name: "index_stats_on_name_and_date", unique: true
  end

end
