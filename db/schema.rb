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

ActiveRecord::Schema.define(:version => 20120909192507) do

  create_table "checks", :force => true do |t|
    t.integer  "word_id"
    t.integer  "oldstat"
    t.integer  "newstat"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "checks", ["word_id"], :name => "index_checks_on_word_id"

  create_table "clips", :force => true do |t|
    t.integer  "word_id"
    t.integer  "status",     :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "inverts", :force => true do |t|
    t.string  "token"
    t.integer "item_id"
  end

  add_index "inverts", ["token"], :name => "index_inverts_on_token"

  create_table "items", :force => true do |t|
    t.string "entry"
    t.text   "body"
  end

  add_index "items", ["entry"], :name => "index_items_on_entry"

  create_table "levels", :force => true do |t|
    t.string  "word"
    t.integer "level"
    t.string  "definition"
    t.boolean "known",      :default => false
  end

  add_index "levels", ["word"], :name => "index_levels_on_word"

  create_table "words", :force => true do |t|
    t.string  "entry"
    t.integer "level",      :default => 0
    t.text    "definition"
    t.string  "thesaurus",  :default => "none"
  end

end
