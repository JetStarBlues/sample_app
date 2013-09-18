class User < ActiveRecord::Base

	attr_accessor	:password

	#attributes that are accessible through the website
	attr_accessible :name, :email, :password, :password_confirmation

	#Lesson 66 - associations with other models
	has_many :microposts, :dependent => :destroy  #when delete user, also delete assoc microposts

    #check if name & email present
    	#Lesson 36
    	email_regex = /\A[\w\-.]+@[a-z\d\_]{2,}+\.[a-z]{2,}\z/i

	    validates :name,  :presence => true,
	    				  :length   => { :maximum => 50 }
	    validates :email, :presence    => true,
	    				  :format      => { :with => email_regex },
	    				  #:uniqueness => true
	    				  :uniqueness  => { :case_sensitive => false } 
	#password
		validates :password, :presence     => true,
							 :confirmation => true,
							 :length	   => { :within => 6..40 }

		before_save :encrypt_password

		def has_password?(submitted_password)
			encrypted_password == encrypt(submitted_password)
		end

		class << self ##
			def User.authenticate(email, submitted_password)
				#class method...
				user = find_by_email(email)
				return nil if user.nil?   #return nil if email does not exist
				return user if user.has_password?(submitted_password)
				# (user && user.has_password?(submitted_password)) ? user : nil   # one line if-statement
			end

			def authenticate_with_salt (id, cookie_salt)
				# Lesson 54 - sign in
				user = find_by_id(id)
				(user && user.salt == cookie_salt) ? user : nil
			end
		end

		#set as private since only used in User model
		private

			def encrypt_password
				self.salt = make_salt if new_record?     #make a salt only if new record
				self.encrypted_password = encrypt(password)
			end

			def encrypt(string)
				secure_hash("#{salt}--#{string}")
			end

			def make_salt
				secure_hash("#{Time.now.utc}--#{password}")
			end

			def secure_hash(string)
				Digest::SHA2.hexdigest(string)
			end
		

end
