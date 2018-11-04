
# frozen_string_literal: true
require 'sequel'

Sequel.migration do

 change do
   create_table(:events) do
     primary_key :id
     
     Integer     :origin_id, unique: true
     String      :title, unique: true, null: false
     String      :description
     
     DateTime :created_at
     DateTime :updated_at
   end
 end
end