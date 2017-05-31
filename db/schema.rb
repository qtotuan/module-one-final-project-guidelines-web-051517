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

ActiveRecord::Schema.define(version: 20170530202215) do

  create_table "boroughs", force: :cascade do |t|
    t.string "name"
  end

  create_table "incidenttype_boroughs", force: :cascade do |t|
    t.integer  "borough_id"
    t.integer  "incidenttype_id"
    t.datetime "open_date"
    t.datetime "close_date"
    t.index ["borough_id"], name: "index_incidenttype_boroughs_on_borough_id"
    t.index ["incidenttype_id"], name: "index_incidenttype_boroughs_on_incidenttype_id"
  end

  create_table "incidenttypes", force: :cascade do |t|
    t.string "name"
  end

end
