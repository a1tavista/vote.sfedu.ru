class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## OpenID
      t.string :identity_url, null: false
      t.string :nickname, null: false

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip

      t.integer :role, null: false, default: 0
      t.references :kind, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :identity_url, unique: true
  end
end
