class CreateSwitches < ActiveRecord::Migration
  def change
    create_table :switches do |t|
      t.string :name
      t.string :ipaddress
      t.string :user_name
      t.string :switch_password
      t.string :enable_password
      t.string :community
      t.string :serial
      t.string :notes
      t.datetime :contacted_at
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
