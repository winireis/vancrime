# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_28_141348) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crimes", force: :cascade do |t|
    t.bigint "offence_id"
    t.bigint "site_id"
    t.bigint "date_d_id"
    t.bigint "time_d_id"
    t.integer "counter", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date_d_id"], name: "index_crimes_on_date_d_id"
    t.index ["offence_id"], name: "index_crimes_on_offence_id"
    t.index ["site_id"], name: "index_crimes_on_site_id"
    t.index ["time_d_id"], name: "index_crimes_on_time_d_id"
  end

  create_table "date_ds", force: :cascade do |t|
    t.string "fulldate"
    t.integer "year"
    t.integer "month"
    t.integer "weekday"
    t.integer "day"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day"], name: "index_date_ds_on_day"
    t.index ["fulldate"], name: "index_date_ds_on_fulldate", unique: true
    t.index ["month"], name: "index_date_ds_on_month"
    t.index ["weekday"], name: "index_date_ds_on_weekday"
    t.index ["year"], name: "index_date_ds_on_year"
  end

  create_table "offences", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_offences_on_name", unique: true
  end

  create_table "sites", force: :cascade do |t|
    t.string "neighbourhood"
    t.string "block"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["block"], name: "index_sites_on_block"
    t.index ["neighbourhood", "block"], name: "index_sites_on_neighbourhood_and_block", unique: true
    t.index ["neighbourhood"], name: "index_sites_on_neighbourhood"
  end

  create_table "time_ds", force: :cascade do |t|
    t.string "fulltime"
    t.integer "hour"
    t.integer "minute"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fulltime"], name: "index_time_ds_on_fulltime", unique: true
    t.index ["hour"], name: "index_time_ds_on_hour"
    t.index ["minute"], name: "index_time_ds_on_minute"
  end

end
