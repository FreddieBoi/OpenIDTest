# == Schema Information
# Schema version: 20110408140226
#
# Table name: users
#
#  id           :integer         not null, primary key
#  identity_url :string(255)
#  fullname     :string(255)
#  email        :string(255)
#  gender       :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	devise :openid_authenticatable

	# Setup accessible (or protected) attributes for your model
	attr_accessible :identity_url, :fullname, :email, :gender

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :identity_url, :presence => true
	validates :email, :format => { :with => email_regex } #, :presence => true
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
			when "fullname"
				self.fullname = value
			when "email"
				self.email = value
			when "gender"
				self.gender = value
			else
			logger.error "Unknown OpenID field: #{key}"
			end
		end
	end

end
