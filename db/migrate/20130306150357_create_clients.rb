class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :description
      t.integer :server_id
      t.timestamps
    end
  end
end
