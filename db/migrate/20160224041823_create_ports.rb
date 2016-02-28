class CreatePorts < ActiveRecord::Migration
  def change
    create_table :ports do |t|
      t.integer :int_idx 
      t.string :port_name
      t.integer :input
      t.integer :output
      t.string :mac_address
      t.string :status
      t.references :switch, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
