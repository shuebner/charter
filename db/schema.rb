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

ActiveRecord::Schema.define(:version => 20121217083011) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "attachments", :force => true do |t|
    t.string   "type"
    t.integer  "attachable_id",    :null => false
    t.string   "attachable_type",  :null => false
    t.string   "attachment_name"
    t.string   "attachment_uid",   :null => false
    t.string   "attachment_title", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "order",            :null => false
  end

  create_table "boat_bookings", :force => true do |t|
    t.integer  "customer_number", :null => false
    t.integer  "boat_id",         :null => false
    t.string   "number",          :null => false
    t.string   "slug",            :null => false
    t.datetime "begin_date",      :null => false
    t.datetime "end_date",        :null => false
    t.integer  "adults",          :null => false
    t.integer  "children",        :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "boat_bookings", ["number"], :name => "index_boat_bookings_on_number"
  add_index "boat_bookings", ["slug"], :name => "index_boat_bookings_on_slug"

  create_table "boat_inquiries", :force => true do |t|
    t.integer "boat_id",    :null => false
    t.date    "begin_date", :null => false
    t.date    "end_date",   :null => false
    t.integer "adults",     :null => false
    t.integer "children"
  end

  create_table "boat_owners", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "slug",       :null => false
    t.boolean  "is_self",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "boat_owners", ["slug"], :name => "index_boat_owners_on_slug", :unique => true

  create_table "boat_price_types", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "duration",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "boat_prices", :force => true do |t|
    t.decimal  "value",              :precision => 7, :scale => 2, :null => false
    t.integer  "boat_price_type_id",                               :null => false
    t.integer  "season_id",                                        :null => false
    t.integer  "boat_id",                                          :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "boat_prices", ["boat_id"], :name => "index_boat_prices_on_boat_id"
  add_index "boat_prices", ["boat_price_type_id"], :name => "index_boat_prices_on_boat_price_type_id"
  add_index "boat_prices", ["season_id"], :name => "index_boat_prices_on_season_id"

  create_table "boats", :force => true do |t|
    t.string   "manufacturer",                                             :null => false
    t.string   "model",                                                    :null => false
    t.decimal  "length_hull",                :precision => 5, :scale => 3
    t.decimal  "length_waterline",           :precision => 5, :scale => 3
    t.decimal  "beam",                       :precision => 5, :scale => 3
    t.decimal  "draft",                      :precision => 5, :scale => 3
    t.decimal  "air_draft",                  :precision => 5, :scale => 3
    t.decimal  "displacement",               :precision => 5, :scale => 3
    t.decimal  "sail_area_jib",              :precision => 5, :scale => 2
    t.decimal  "sail_area_genoa",            :precision => 5, :scale => 2
    t.decimal  "sail_area_main_sail",        :precision => 5, :scale => 2
    t.integer  "tank_volume_diesel"
    t.integer  "tank_volume_fresh_water"
    t.integer  "tank_volume_waste_water"
    t.integer  "permanent_bunks"
    t.integer  "convertible_bunks"
    t.integer  "max_no_of_people"
    t.integer  "recommended_no_of_people"
    t.decimal  "headroom_saloon",            :precision => 5, :scale => 3
    t.string   "name",                                                     :null => false
    t.string   "slug",                                                     :null => false
    t.integer  "year_of_construction",                                     :null => false
    t.integer  "year_of_refit"
    t.string   "engine_manufacturer"
    t.string   "engine_model"
    t.string   "engine_design"
    t.integer  "engine_output"
    t.integer  "battery_capacity"
    t.boolean  "available_for_boat_charter",                               :null => false
    t.boolean  "available_for_bunk_charter",                               :null => false
    t.decimal  "deposit",                    :precision => 7, :scale => 2
    t.decimal  "cleaning_charge",            :precision => 7, :scale => 2
    t.decimal  "fuel_charge",                :precision => 7, :scale => 2
    t.decimal  "gas_charge",                 :precision => 7, :scale => 2
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.integer  "boat_owner_id",                                            :null => false
    t.integer  "port_id",                                                  :null => false
  end

  add_index "boats", ["boat_owner_id"], :name => "index_boats_on_boat_owner_id"
  add_index "boats", ["port_id"], :name => "index_boats_on_port_id"
  add_index "boats", ["slug"], :name => "index_boats_on_slug"

  create_table "captains", :force => true do |t|
    t.string   "first_name",              :null => false
    t.string   "last_name",               :null => false
    t.string   "slug",                    :null => false
    t.string   "phone_mobile",            :null => false
    t.string   "email"
    t.string   "sailing_certificates"
    t.string   "additional_certificates"
    t.text     "description"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "captains", ["slug"], :name => "index_captains_on_slug", :unique => true

  create_table "customers", :force => true do |t|
    t.string   "first_name",                     :null => false
    t.string   "last_name",                      :null => false
    t.string   "gender",            :limit => 1, :null => false
    t.string   "phone_landline"
    t.string   "phone_mobile"
    t.string   "email"
    t.string   "street_name"
    t.string   "street_number"
    t.string   "zip_code"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "slug"
    t.integer  "number",                         :null => false
    t.boolean  "has_sks_or_higher"
  end

  add_index "customers", ["first_name"], :name => "index_customers_on_first_name"
  add_index "customers", ["last_name"], :name => "index_customers_on_last_name"
  add_index "customers", ["number"], :name => "index_customers_on_number", :unique => true
  add_index "customers", ["slug"], :name => "index_customers_on_slug", :unique => true

  create_table "inquiries", :force => true do |t|
    t.string   "first_name", :null => false
    t.string   "last_name",  :null => false
    t.string   "email",      :null => false
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
  end

  create_table "paragraphs", :force => true do |t|
    t.string   "heading"
    t.text     "text"
    t.integer  "order",          :null => false
    t.integer  "static_page_id", :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "picture_uid"
    t.string   "picture_name"
  end

  add_index "paragraphs", ["order"], :name => "index_paragraphs_on_order"
  add_index "paragraphs", ["static_page_id"], :name => "index_paragraphs_on_static_page_id"

  create_table "ports", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "slug",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ports", ["slug"], :name => "index_ports_on_slug", :unique => true

  create_table "seasons", :force => true do |t|
    t.string   "name",       :null => false
    t.date     "begin_date", :null => false
    t.date     "end_date",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "static_pages", :force => true do |t|
    t.string   "slug",         :limit => 30,  :null => false
    t.string   "title",        :limit => 100, :null => false
    t.string   "heading",      :limit => 100
    t.text     "text"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "picture_uid"
    t.string   "picture_name"
  end

  add_index "static_pages", ["slug"], :name => "index_static_pages_on_name"

  create_table "trip_bookings", :force => true do |t|
    t.integer  "trip_date_id",    :null => false
    t.string   "number",          :null => false
    t.string   "slug",            :null => false
    t.integer  "no_of_bunks",     :null => false
    t.datetime "cancelled_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "customer_number"
  end

  add_index "trip_bookings", ["customer_number"], :name => "index_trip_bookings_on_customer_number"
  add_index "trip_bookings", ["number"], :name => "index_trip_bookings_on_number", :unique => true
  add_index "trip_bookings", ["slug"], :name => "index_trip_bookings_on_slug", :unique => true
  add_index "trip_bookings", ["trip_date_id"], :name => "index_trip_bookings_on_trip_date_id"

  create_table "trip_dates", :force => true do |t|
    t.integer  "trip_id",    :null => false
    t.datetime "begin_date", :null => false
    t.datetime "end_date",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "trip_dates", ["begin_date"], :name => "index_trip_dates_on_begin"
  add_index "trip_dates", ["trip_id"], :name => "index_trip_dates_on_trip_id"

  create_table "trip_inquiries", :force => true do |t|
    t.integer "trip_date_id", :null => false
    t.integer "bunks",        :null => false
  end

  create_table "trips", :force => true do |t|
    t.integer  "boat_id",                                   :null => false
    t.string   "name",                                      :null => false
    t.string   "slug",                                      :null => false
    t.text     "description",                               :null => false
    t.integer  "no_of_bunks",                               :null => false
    t.decimal  "price",       :precision => 7, :scale => 2, :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "trips", ["boat_id"], :name => "index_trips_on_boat_id"
  add_index "trips", ["slug"], :name => "index_trips_on_slug", :unique => true

  create_view "view_boat_inquiries", "select `inquiries`.`id` AS `id`,`inquiries`.`first_name` AS `first_name`,`inquiries`.`last_name` AS `last_name`,`inquiries`.`email` AS `email`,`inquiries`.`text` AS `text`,`inquiries`.`created_at` AS `created_at`,`inquiries`.`updated_at` AS `updated_at`,`inquiries`.`type` AS `type`,`boat_inquiries`.`boat_id` AS `boat_id`,`boat_inquiries`.`begin_date` AS `begin_date`,`boat_inquiries`.`end_date` AS `end_date`,`boat_inquiries`.`adults` AS `adults`,`boat_inquiries`.`children` AS `children` from (`inquiries` join `boat_inquiries`) where (`inquiries`.`id` = `boat_inquiries`.`id`)", :force => true do |v|
    v.column :id
    v.column :first_name
    v.column :last_name
    v.column :email
    v.column :text
    v.column :created_at
    v.column :updated_at
    v.column :type
    v.column :boat_id
    v.column :begin_date
    v.column :end_date
    v.column :adults
    v.column :children
  end

  create_view "view_trip_inquiries", "select `inquiries`.`id` AS `id`,`inquiries`.`first_name` AS `first_name`,`inquiries`.`last_name` AS `last_name`,`inquiries`.`email` AS `email`,`inquiries`.`text` AS `text`,`inquiries`.`created_at` AS `created_at`,`inquiries`.`updated_at` AS `updated_at`,`inquiries`.`type` AS `type`,`trip_inquiries`.`trip_date_id` AS `trip_date_id`,`trip_inquiries`.`bunks` AS `bunks` from (`inquiries` join `trip_inquiries`) where (`inquiries`.`id` = `trip_inquiries`.`id`)", :force => true do |v|
    v.column :id
    v.column :first_name
    v.column :last_name
    v.column :email
    v.column :text
    v.column :created_at
    v.column :updated_at
    v.column :type
    v.column :trip_date_id
    v.column :bunks
  end

end
