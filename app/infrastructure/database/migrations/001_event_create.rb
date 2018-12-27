# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id

      String :origin_id, unique: true
      String :country_code, null: false
      String :category, null: false
      String :title, unique: false, null: false
      String :description, null: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
