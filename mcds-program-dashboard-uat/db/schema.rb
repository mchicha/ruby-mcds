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

ActiveRecord::Schema.define(version: 20160901200939) do

  create_table "agencies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "agencies_geographies", id: false, force: :cascade do |t|
    t.integer  "agency_id",    limit: 4, null: false
    t.integer  "geography_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agencies_geographies", ["agency_id"], name: "index_agencies_geographies_on_agency_id", using: :btree
  add_index "agencies_geographies", ["geography_id"], name: "index_agencies_geographies_on_geography_id", using: :btree

  create_table "agencies_users", id: false, force: :cascade do |t|
    t.integer  "agency_id",  limit: 4, null: false
    t.integer  "user_id",    limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agencies_users", ["agency_id"], name: "index_agencies_users_on_agency_id", using: :btree
  add_index "agencies_users", ["user_id"], name: "index_agencies_users_on_user_id", using: :btree

  create_table "alert_geographies", force: :cascade do |t|
    t.integer  "alert_id",     limit: 4
    t.integer  "geography_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alert_geographies", ["alert_id"], name: "index_alert_geographies_on_alert_id", using: :btree
  add_index "alert_geographies", ["geography_id"], name: "index_alert_geographies_on_geography_id", using: :btree

  create_table "alerts", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.boolean  "archived",                     default: false
    t.text     "body",           limit: 65535
    t.date     "post_date"
    t.date     "remove_date"
    t.string   "alertable_type", limit: 255
    t.integer  "alertable_id",   limit: 4
    t.integer  "user_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_all"
  end

  add_index "alerts", ["alertable_id"], name: "index_alerts_on_alertable_id", using: :btree
  add_index "alerts", ["alertable_type"], name: "index_alerts_on_alertable_type", using: :btree

  create_table "calendars", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calendars", ["user_id"], name: "index_calendars_on_user_id", using: :btree

  create_table "captures", force: :cascade do |t|
    t.string   "event",      limit: 255
    t.integer  "user_id",    limit: 4
    t.string   "session_id", limit: 255
    t.integer  "user_role",  limit: 4
    t.text     "data",       limit: 65535
    t.boolean  "archived",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "color_blocks", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "start_hex",  limit: 255
    t.string   "end_hex",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "color_blocks_programs", id: false, force: :cascade do |t|
    t.integer  "color_block_id", limit: 4, null: false
    t.integer  "program_id",     limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "color_blocks_programs", ["color_block_id"], name: "index_color_blocks_programs_on_color_block_id", using: :btree
  add_index "color_blocks_programs", ["program_id"], name: "index_color_blocks_programs_on_program_id", using: :btree

  create_table "color_blocks_users", id: false, force: :cascade do |t|
    t.integer  "color_block_id", limit: 4, null: false
    t.integer  "user_id",        limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "color_blocks_users", ["color_block_id"], name: "index_color_blocks_users_on_color_block_id", using: :btree
  add_index "color_blocks_users", ["user_id"], name: "index_color_blocks_users_on_user_id", using: :btree

  create_table "contact_list_messages", force: :cascade do |t|
    t.integer  "message_id",      limit: 4
    t.integer  "contact_list_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_list_messages", ["contact_list_id"], name: "index_contact_list_messages_on_contact_list_id", using: :btree
  add_index "contact_list_messages", ["message_id"], name: "index_contact_list_messages_on_message_id", using: :btree

  create_table "contact_list_users", force: :cascade do |t|
    t.integer  "contact_list_id", limit: 4, null: false
    t.integer  "user_id",         limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_list_users", ["contact_list_id"], name: "index_contact_list_users_on_contact_list_id", using: :btree
  add_index "contact_list_users", ["user_id"], name: "index_contact_list_users_on_user_id", using: :btree

  create_table "contact_lists", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    limit: 4
  end

  add_index "contact_lists", ["user_id"], name: "index_contact_lists_on_user_id", using: :btree

  create_table "date_ranges", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "date_type_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "date_ranges", ["date_type_id"], name: "index_date_ranges_on_date_type_id", using: :btree

  create_table "date_ranges_programs", id: false, force: :cascade do |t|
    t.integer  "date_range_id", limit: 4, null: false
    t.integer  "program_id",    limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "date_ranges_programs", ["date_range_id"], name: "index_date_ranges_programs_on_date_range_id", using: :btree
  add_index "date_ranges_programs", ["program_id"], name: "index_date_ranges_programs_on_program_id", using: :btree

  create_table "date_types", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "end_date_required",             default: false
    t.boolean  "required",                      default: false
    t.integer  "sort_order",        limit: 4,   default: 1
    t.string   "class_name",        limit: 255
    t.string   "display_name",      limit: 255
    t.boolean  "show_on_calendar",              default: false
    t.string   "fa_icon",           limit: 255
    t.string   "icon_color",        limit: 255
  end

  create_table "delivery_methods", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_elements", force: :cascade do |t|
    t.integer  "document_id",  limit: 4
    t.integer  "element_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "geography_id", limit: 4
  end

  add_index "document_elements", ["document_id"], name: "index_document_elements_on_document_id", using: :btree
  add_index "document_elements", ["element_id"], name: "index_document_elements_on_element_id", using: :btree

  create_table "document_notes", force: :cascade do |t|
    t.integer  "document_id", limit: 4
    t.integer  "note_id",     limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "document_notes", ["document_id", "note_id"], name: "index_document_id_note_id", using: :btree

  create_table "document_schematics", force: :cascade do |t|
    t.integer  "schematic_id", limit: 4
    t.integer  "document_id",  limit: 4
    t.integer  "element_id",   limit: 4
    t.boolean  "active",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "geography_id", limit: 4
  end

  add_index "document_schematics", ["document_id"], name: "index_document_schematics_on_document_id", using: :btree
  add_index "document_schematics", ["element_id"], name: "index_document_schematics_on_element_id", using: :btree
  add_index "document_schematics", ["schematic_id"], name: "index_document_schematics_on_schematic_id", using: :btree

  create_table "documentables", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.float    "height",       limit: 24
    t.float    "width",        limit: 24
    t.integer  "type",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_of",      limit: 4,     default: 0
    t.string   "filename",     limit: 255
    t.integer  "parent_id",    limit: 4
    t.text     "values",       limit: 65535
    t.string   "zone_id",      limit: 255
    t.integer  "source_id",    limit: 4
    t.float    "print_scale",  limit: 24,    default: 1.0
    t.string   "background",   limit: 255
    t.string   "digest",       limit: 255
    t.integer  "origin_id",    limit: 4
    t.integer  "sort_order",   limit: 4,     default: 1
    t.string   "display_name", limit: 255
  end

  add_index "documents", ["parent_id"], name: "index_documents_on_parent_id", using: :btree
  add_index "documents", ["source_id"], name: "index_documents_on_source_id", using: :btree
  add_index "documents", ["zone_id"], name: "index_documents_on_zone_id", using: :btree

  create_table "documents_programs", force: :cascade do |t|
    t.integer  "document_id", limit: 4
    t.integer  "program_id",  limit: 4
    t.integer  "element_id",  limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "documents_programs", ["document_id"], name: "index_documents_programs_on_document_id", using: :btree
  add_index "documents_programs", ["element_id"], name: "index_documents_programs_on_element_id", using: :btree
  add_index "documents_programs", ["program_id"], name: "index_documents_programs_on_program_id", using: :btree

  create_table "elements", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.integer  "zindex",                   limit: 4
    t.boolean  "editable",                                  default: true
    t.string   "identity",                 limit: 255
    t.integer  "parent_id",                limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "layout_id",                limit: 4
    t.text     "values",                   limit: 16777215
    t.integer  "primary_dam_asset_id",     limit: 4
    t.string   "primary_dam_asset_path",   limit: 255
    t.integer  "source_id",                limit: 4
    t.string   "layer_name",               limit: 255
    t.integer  "type_of",                  limit: 4,        default: 0
    t.string   "group",                    limit: 255
    t.integer  "secondary_dam_asset_id",   limit: 4
    t.string   "secondary_dam_asset_path", limit: 255
    t.integer  "primary_program_id",       limit: 4
    t.integer  "secondary_program_id",     limit: 4
    t.boolean  "grayscale",                                 default: false
  end

  create_table "epics", force: :cascade do |t|
    t.integer  "origin_id",   limit: 4
    t.integer  "template_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "epics", ["origin_id"], name: "index_epics_on_origin_id", using: :btree
  add_index "epics", ["template_id"], name: "index_epics_on_template_id", using: :btree

  create_table "espinita_audits", force: :cascade do |t|
    t.integer  "auditable_id",    limit: 4
    t.string   "auditable_type",  limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "user_type",       limit: 255
    t.text     "audited_changes", limit: 65535
    t.string   "comment",         limit: 255
    t.integer  "version",         limit: 4
    t.string   "action",          limit: 255
    t.string   "remote_address",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "espinita_audits", ["auditable_type", "auditable_id"], name: "index_espinita_audits_on_auditable_type_and_auditable_id", using: :btree
  add_index "espinita_audits", ["user_type", "user_id"], name: "index_espinita_audits_on_user_type_and_user_id", using: :btree

  create_table "geographies", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry",          limit: 255
    t.integer  "geography_type_id", limit: 4
    t.integer  "ancestry_depth",    limit: 4,   default: 0
    t.integer  "coop_id",           limit: 4
  end

  add_index "geographies", ["ancestry"], name: "index_geographies_on_ancestry", using: :btree
  add_index "geographies", ["geography_type_id"], name: "index_geographies_on_geography_type_id", using: :btree

  create_table "geographies_programs", force: :cascade do |t|
    t.integer "geography_id", limit: 4, null: false
    t.integer "program_id",   limit: 4, null: false
  end

  add_index "geographies_programs", ["geography_id"], name: "index_geographies_programs_on_geography_id", using: :btree
  add_index "geographies_programs", ["program_id"], name: "index_geographies_programs_on_program_id", using: :btree

  create_table "geographies_schematics", force: :cascade do |t|
    t.integer  "schematic_id", limit: 4
    t.integer  "geography_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geographies_schematics", ["schematic_id", "geography_id"], name: "index_geographies_schematics_on_schematic_id_and_geography_id", using: :btree

  create_table "geography_messages", force: :cascade do |t|
    t.integer  "geography_id", limit: 4
    t.integer  "message_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geography_messages", ["geography_id"], name: "index_geography_messages_on_geography_id", using: :btree
  add_index "geography_messages", ["message_id"], name: "index_geography_messages_on_message_id", using: :btree

  create_table "geography_moments", force: :cascade do |t|
    t.integer  "geography_id", limit: 4
    t.integer  "moment_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geography_moments", ["geography_id"], name: "index_geography_moments_on_geography_id", using: :btree
  add_index "geography_moments", ["moment_id"], name: "index_geography_moments_on_moment_id", using: :btree

  create_table "geography_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geography_types", ["name"], name: "index_geography_types_on_name", using: :btree

  create_table "geography_users", force: :cascade do |t|
    t.integer  "geography_id", limit: 4
    t.integer  "integer",      limit: 4
    t.integer  "user_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geography_users", ["geography_id"], name: "index_geography_users_on_geography_id", using: :btree
  add_index "geography_users", ["user_id"], name: "index_geography_users_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "image",        limit: 255
    t.integer  "schematic_id", limit: 4
    t.integer  "document_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["document_id"], name: "index_images_on_document_id", using: :btree
  add_index "images", ["schematic_id"], name: "index_images_on_schematic_id", using: :btree

  create_table "killswitches", force: :cascade do |t|
    t.string  "name",        limit: 255
    t.boolean "killed",                  default: false
    t.string  "description", limit: 255
  end

  create_table "lookup_table_rows", force: :cascade do |t|
    t.string   "key",             limit: 255
    t.boolean  "archived",                      default: false
    t.integer  "lookup_table_id", limit: 4
    t.text     "columns",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lookup_table_rows", ["lookup_table_id"], name: "index_lookup_table_rows_on_lookup_table_id", using: :btree

  create_table "lookup_tables", force: :cascade do |t|
    t.string   "table_name",     limit: 255
    t.string   "key_field_name", limit: 255
    t.boolean  "archived",                   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_users", force: :cascade do |t|
    t.integer  "message_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_users", ["message_id"], name: "index_message_users_on_message_id", using: :btree
  add_index "message_users", ["user_id"], name: "index_message_users_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "subject",       limit: 255
    t.text     "content",       limit: 65535
    t.boolean  "sent",                        default: false
    t.datetime "send_date"
    t.boolean  "archived",                    default: false
    t.datetime "publish_date"
    t.datetime "archive_date"
    t.string   "delivery_type", limit: 255
    t.integer  "user_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "moments", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.boolean  "archived",                      default: false
    t.text     "body",            limit: 65535
    t.date     "post_date"
    t.date     "remove_date"
    t.string   "momentable_type", limit: 255
    t.integer  "momentable_id",   limit: 4
    t.integer  "user_id",         limit: 4
    t.boolean  "show_all",                      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moments", ["momentable_id"], name: "index_moments_on_momentable_id", using: :btree
  add_index "moments", ["momentable_type"], name: "index_moments_on_momentable_type", using: :btree

  create_table "notes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "body",       limit: 65535
    t.float    "x",          limit: 24,    default: 0.0
    t.float    "y",          limit: 24,    default: 0.0
    t.float    "width",      limit: 24
    t.float    "height",     limit: 24
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "source_id",  limit: 4
    t.integer  "parent_id",  limit: 4
    t.boolean  "removed",                  default: false
  end

  create_table "predefined_attributes", force: :cascade do |t|
    t.string   "table",      limit: 255
    t.string   "column",     limit: 255
    t.string   "value",      limit: 255
    t.integer  "send_on",    limit: 4
    t.text     "values",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "number",             limit: 255
    t.integer  "user_id",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "report_id",          limit: 255
    t.integer  "status_id",          limit: 4
    t.integer  "delivery_method_id", limit: 4
    t.text     "notes",              limit: 65535
    t.string   "thumb_image_url",    limit: 255
    t.text     "pos",                limit: 65535
    t.integer  "calendar_display",   limit: 4,     default: 0
  end

  add_index "programs", ["delivery_method_id"], name: "index_programs_on_delivery_method_id", using: :btree
  add_index "programs", ["status_id"], name: "index_programs_on_status_id", using: :btree
  add_index "programs", ["user_id"], name: "index_programs_on_user_id", using: :btree

  create_table "resources", force: :cascade do |t|
    t.text     "description",       limit: 65535
    t.string   "file",              limit: 255
    t.integer  "resourceable_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resourceable_type", limit: 255
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schematics", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.date     "release_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",              limit: 4
    t.integer  "parent_id",           limit: 4
    t.integer  "epic_id",             limit: 4
    t.integer  "sch_type",            limit: 4,   default: 0
    t.integer  "geography_id",        limit: 4
    t.integer  "source_id",           limit: 4
    t.integer  "last_modified_by_id", limit: 4
  end

  add_index "schematics", ["epic_id"], name: "index_schematics_on_epic_id", using: :btree
  add_index "schematics", ["last_modified_by_id"], name: "index_schematics_on_last_modified_by_id", using: :btree
  add_index "schematics", ["parent_id"], name: "index_schematics_on_parent_id", using: :btree
  add_index "schematics", ["source_id"], name: "index_schematics_on_source_id", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order", limit: 4,   default: 0
  end

  create_table "traffic_reports", force: :cascade do |t|
    t.integer  "incident_type", limit: 4
    t.boolean  "archived",                    default: false
    t.boolean  "seen",                        default: false
    t.text     "body",          limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",            limit: 255
    t.string   "last_name",             limit: 255
    t.string   "email",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cas_user_id",           limit: 4
    t.integer  "role_id",               limit: 4
    t.integer  "role",                  limit: 4,   default: 3
    t.boolean  "active",                            default: true
    t.integer  "selected_geography_id", limit: 4
  end

  create_table "versions", force: :cascade do |t|
    t.integer  "epic_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zones", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "sort_order", limit: 4,   default: 1
    t.boolean  "archived",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
