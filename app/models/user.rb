class User < ActiveRecord::Base
	attr_accessible :name, :email

    #check if name & email present
    	#Lesson 36
    	email_regex = /\A[\w\-.]+@[a-z\d\_]{2,}+\.[a-z]{2,}\z/i

	    validates :name,  :presence => true,
	    				  :length   => { :maximum => 50 }
	    validates :email, :presence    => true,
	    				  :format      => { :with => email_regex },
	    				  #:uniqueness => true
	    				  :uniqueness  => { :case_sensitive => false } 

end
