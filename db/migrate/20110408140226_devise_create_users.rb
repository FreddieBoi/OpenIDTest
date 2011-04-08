class DeviseCreateUsers < ActiveRecord::Migration
	def self.up
		create_table(:users) do |t|
			t.openid_authenticatable
			t.string :name
			t.string :email
			t.string :gender
		end

		add_index :users, :identity_url,         :unique => true
	# add_index :users, :confirmation_token,   :unique => true
	# add_index :users, :unlock_token,         :unique => true
	# add_index :users, :authentication_token, :unique => true
	end

	def self.down
		drop_table :users
	end
end
