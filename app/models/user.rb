class User < ActiveRecord::Base

	attr_accessor	:password

	#attributes that are accessible through the website
	attr_accessible :name, :email, :password, :password_confirmation

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

end
