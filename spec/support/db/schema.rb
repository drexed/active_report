# frozen_string_literal: true

ActiveRecord::Schema.define(version: 1) do
  create_table :cars, force: :cascade do |t|
    t.string :name
    t.integer :speed
    t.integer :hp
    t.boolean :crash_safety_rated
    t.string :created_at
  end
end
