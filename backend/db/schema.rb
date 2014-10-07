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

ActiveRecord::Schema.define(:version => 20141007211914) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "line1"
    t.string   "line2"
    t.string   "line3"
    t.string   "city"
    t.string   "region"
    t.string   "postal_code"
    t.string   "country"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "batches", :force => true do |t|
    t.string   "name"
    t.integer  "promotion_id"
    t.boolean  "active"
    t.boolean  "deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "batches", ["promotion_id"], :name => "index_batches_on_promotion_id"

  create_table "bundleds", :force => true do |t|
    t.integer  "bundle_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "qty"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "bundleds", ["bundle_id"], :name => "index_bundleds_on_bundle_id"
  add_index "bundleds", ["item_type", "item_id"], :name => "index_bundleds_on_item_type_and_item_id"

  create_table "bundles", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "active"
    t.datetime "created_at",  :null => false
    t.boolean  "deleted"
    t.datetime "updated_at"
  end

  create_table "coupons", :force => true do |t|
    t.string   "code"
    t.integer  "batch_id"
    t.boolean  "used"
    t.integer  "used_by"
    t.datetime "used_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupons", ["batch_id"], :name => "index_coupons_on_batch_id"
  add_index "coupons", ["code"], :name => "index_coupons_on_code"
  add_index "coupons", ["used_by"], :name => "index_coupons_on_used_by"

  create_table "currencies", :force => true do |t|
    t.string   "code"
    t.string   "sign"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "currencies", ["code"], :name => "index_currencies_on_code"

  create_table "digital_items", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "active"
    t.datetime "created_at",  :null => false
    t.boolean  "deleted"
    t.datetime "updated_at"
  end

  create_table "discounts", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",       :precision => 5, :scale => 4
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "discounts", ["name"], :name => "index_discounts_on_name"

  create_table "fulfillments", :force => true do |t|
    t.string   "type"
    t.integer  "order_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.integer  "qty"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fulfillments", ["item_type", "item_id"], :name => "index_fulfillments_on_item_type_and_item_id"
  add_index "fulfillments", ["order_id"], :name => "index_fulfillments_on_order_id"
  add_index "fulfillments", ["type"], :name => "index_fulfillments_on_type"

  create_table "orders", :force => true do |t|
    t.string   "uuid"
    t.integer  "purchase_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.integer  "currency_id"
    t.decimal  "amount",      :precision => 20, :scale => 2
    t.decimal  "tax",         :precision => 20, :scale => 2
    t.integer  "qty"
    t.boolean  "deleted"
    t.integer  "refund_id"
    t.datetime "created_at"
    t.decimal  "tax_rate",    :precision => 5,  :scale => 4
    t.datetime "updated_at"
  end

  add_index "orders", ["item_type", "item_id"], :name => "index_orders_on_item_type_and_item_id"
  add_index "orders", ["purchase_id"], :name => "index_orders_on_purchase_id"
  add_index "orders", ["uuid"], :name => "index_orders_on_uuid"

  create_table "ownerships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.string   "item_type"
    t.string   "item_id"
    t.integer  "qty"
    t.boolean  "deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ownerships", ["item_type", "item_id"], :name => "index_ownerships_on_item_type_and_item_id"
  add_index "ownerships", ["user_id"], :name => "index_ownerships_on_user_id"

  create_table "payment_methods", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.decimal  "balance",     :precision => 20, :scale => 2
    t.datetime "created_at"
    t.integer  "currency_id"
    t.datetime "updated_at"
  end

  add_index "payment_methods", ["user_id"], :name => "index_payment_methods_on_user_id"

  create_table "physical_items", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "active"
    t.integer  "qty"
    t.datetime "created_at",  :null => false
    t.boolean  "deleted"
    t.datetime "updated_at"
  end

  create_table "pricepoint_prices", :force => true do |t|
    t.decimal  "amount",        :precision => 20, :scale => 2
    t.integer  "pricepoint_id"
    t.integer  "currency_id"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "pricepoint_prices", ["currency_id"], :name => "index_pricepoint_prices_on_currency_id"
  add_index "pricepoint_prices", ["pricepoint_id"], :name => "index_pricepoint_prices_on_pricepoint_id"

  create_table "pricepoints", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pricepoints", ["name"], :name => "index_pricepoints_on_name"

  create_table "prices", :force => true do |t|
    t.string   "name"
    t.integer  "pricepoint_id"
    t.integer  "discount_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["discount_id"], :name => "index_prices_on_discount_id"
  add_index "prices", ["pricepoint_id"], :name => "index_prices_on_pricepoint_id"

  create_table "promotions", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.string   "item_type"
    t.integer  "item_id"
    t.boolean  "active"
    t.boolean  "deleted"
    t.integer  "price_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "promotions", ["item_type", "item_id"], :name => "index_promotions_on_item_type_and_item_id"

  create_table "purchases", :force => true do |t|
    t.integer  "user_id"
    t.integer  "payment_method_id"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.integer  "payment_id"
    t.boolean  "committed"
    t.datetime "committed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "purchases", ["user_id"], :name => "index_purchases_on_user_id"

  create_table "shipments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.integer  "qty"
    t.integer  "shipping_address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shipments", ["item_type", "item_id"], :name => "index_shipments_on_item_type_and_item_id"
  add_index "shipments", ["user_id"], :name => "index_shipments_on_user_id"

  create_table "statuses", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["source_id", "source_type"], :name => "index_statuses_on_source_id_and_source_type"

  create_table "store_items", :force => true do |t|
    t.string   "name"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at", :null => false
    t.boolean  "deleted"
    t.integer  "price_id"
    t.datetime "updated_at"
  end

  add_index "store_items", ["item_type", "item_id"], :name => "index_store_items_on_item_type_and_item_id"
  add_index "store_items", ["price_id"], :name => "index_store_items_on_price_id"

  create_table "transactions", :force => true do |t|
    t.string   "uuid"
    t.integer  "user_id"
    t.integer  "payment_method_id"
    t.integer  "billing_address_id"
    t.decimal  "amount",             :precision => 20, :scale => 2
    t.integer  "currency_id"
    t.boolean  "committed"
    t.datetime "committed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["user_id"], :name => "index_transactions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "uuid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.date     "birthdate"
    t.string   "password"
    t.string   "actv_code"
    t.boolean  "confirmed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["uuid"], :name => "index_users_on_uuid"

end
