class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	devise :openid_authenticatable

	# Setup accessible (or protected) attributes for your model
	attr_accessible :identity_url, :name, :email, :gender
	def self.build_from_identity_url(identity_url)
		User.new(:identity_url => identity_url)
	end

	def self.openid_required_fields
		["fullname", "email"]
	end

	def self.openid_optional_fields
		["gender"]
	end

	def openid_fields=(fields)
		fields.each do |key, value|
		# Some AX providers can return multiple values per key
			if value.is_a? Array
				value = value.first
			end

			case key.to_s
			when "fullname", "http://axschema.org/namePerson"
				debugger
				self.name = value
			when "email", "http://axschema.org/contact/email"
				self.email = value
			when "gender", "http://axschema.org/person/gender"
				self.gender = value
			else
			logger.error "Unknown OpenID field: #{key}"
			end
		end
	end

end
