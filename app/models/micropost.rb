class Micropost < ActiveRecord::Base
	attr_accessible :content

	belongs_to :user

	validates :content, :presence => true, 
					   :length   => { :maximum => 150 }
	validates :user_id, :presence => true

	default_scope :order => 'microposts.created_at DESC'


	scope :from_users_followed_by, lambda { |user| followed_by(user) }

	#====
	#Lesson 74	

	#More efficient (less memory/cpu intensive) way of doing below (vs. calling all records) @16:00 
	#is to replace with scope
		# def self.from_users_followed_by(user)
		# 	followed_ids = user.following.map(&:id).join(", ")
		# 	where("user_id IN (#{followed_ids}) OR user_id = ?", user)
		# end

	private 

	def self.followed_by(user)
		#followed_ids = user.following.map(&:id).join(", ")  #user.following is memory expensive smthng about activeRecord
															 #push select action to DB instead?
		#select from DB (rltnshps table) all users where followed_id is same as user_id
		followed_ids = %(SELECT followed_id FROM relationships
						 WHERE follower_id = :user_id)

		where("user_id IN (#{followed_ids}) OR user_id = :user_id", #':user_id' allows for variable use in multiple places??
			  :user_id => user)

		# '%(...)' notation allows you to 1. break a string across lines
		#   							  2. put double quotes in a string without escaping
	end


end
