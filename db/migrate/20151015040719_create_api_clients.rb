class CreateApiClients < ActiveRecord::Migration
  def change
    create_table :api_clients do |t|
      t.string :access_token

      t.timestamps null: false
    end
    add_index :api_clients, :access_token, unique: true
  end
end
