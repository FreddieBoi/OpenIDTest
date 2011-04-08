class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	devise :openid_authenticatable

	# Setup accessible (or protected) attributes for your model
	attr_accessible :identity_url
	def self.create_from_identity_url(identity_url)
		User.new(:identity_url => identity_url)
	end

	def self.openid_required_fields
		["http://axschema.org/contact/email", "http://axschema.org/namePerson/first", "http://axschema.org/namePerson/last"]
	end

	def openid_fields=(fields)
		fields.each do |key, value|
			case key.to_s
			when "http://axschema.org/contact/email"
				self.email = value.to_s
			when "http://axschema.org/namePerson/first"
				self.first_name = value.to_s
			when "http://axschema.org/namePerson/last"
				self.last_name = value.to_s
			end
		end
		self.save!
	end
end
