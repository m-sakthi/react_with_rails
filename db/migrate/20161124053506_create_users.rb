class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, :null => false
      t.string :user_name
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :profile_pic
      t.datetime :activated_at
      t.string :activation_digest
      t.integer :status, :null => false, :default => 0
      t.string :reset_digest
      t.datetime :reset_sent_at

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :user_name, unique: true
  end
end
