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

ActiveRecord::Schema[7.0].define(version: 2023_08_08_201247) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived_at"
    t.index ["name"], name: "index_clients_on_name", unique: true
  end

  create_table "estimated_taxes", force: :cascade do |t|
    t.decimal "value", precision: 8, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "category", null: false
    t.date "expense_date", null: false
    t.decimal "amount", precision: 7, scale: 2
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "logs", force: :cascade do |t|
    t.bigint "project_id"
    t.datetime "start_at", precision: nil, null: false
    t.datetime "end_at", precision: nil
    t.integer "elapsed_seconds"
    t.text "description"
    t.boolean "active", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["project_id"], name: "index_logs_on_project_id"
  end

  create_table "pay_rates", force: :cascade do |t|
    t.date "effective_start_date", null: false
    t.date "effective_end_date"
    t.decimal "rate", precision: 5, scale: 2
    t.boolean "current", default: true, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "short_name", null: false
    t.datetime "archived_at", precision: nil
    t.bigint "client_id"
    t.index ["name"], name: "index_projects_on_name", unique: true
  end

  create_table "saved_filters", force: :cascade do |t|
    t.string "controller", null: false
    t.string "action", null: false
    t.text "filters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "logs", "projects"
  add_foreign_key "projects", "clients"
end
