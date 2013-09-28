class User < ActiveRecord::Base

	attr_accessor	:password

	#attributes that are accessible through the website
	attr_accessible :name, :email, :password, :password_confirmation

	#Lesson 66 - associations with other models
	has_many :microposts,    		 :dependent   => :destroy  #when delete user, also delete assoc microposts
	has_many :relationships, 		 :dependent   => :destroy,
							 		 :foreign_key => "follower_id"
	has_many :reverse_relationships, :dependent   => :destroy,
									 :foreign_key => "followed_id",
									 :class_name  => "Relationship"
	has_many :following,     		 :through     => :relationships,
							 		 :source      => :followed
	has_many :followers, 	 		 :through     => :reverse_relationships,
					     	 		 :source      => :follower

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


	#Lesson 68 @32:00
	def feed
		#return all microposts
			#Micropost.all
		#return current user's microposts
			#self.microposts
		#return all microposts that meet criteria
			#Micropost.where("user_id = ?", self.id)
			Micropost.where("user_id = ?", id)  #use of '?' as placeholder to prevent SQL injection

	end

	#Lesson 72 @22:00
	def following?(followed)
		#self.relationships.find_by_followed_id(followed)
		relationships.find_by_followed_id(followed)		
	end

	def follow!(followed)
		relationships.create!(:followed_id => followed.id)
	end

	def unfollow!(followed)
		relationships.find_by_followed_id(followed).destroy
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
