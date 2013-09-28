require 'faker'

namespace :db do
	desc "Fill database with sample users"
	task :populate => :environment do  # :populate > name of task. To call, 'rake db:populate'
									   # :environment > load Rails environment
		Rake::Task['db:reset'].invoke  #resets database

		make_users
		make_microposts
		make_relationships
	end
end

#====
def make_users

	#User.create!(:name => "Susie Carmichael",  #if reset DB, this would be user whose info we know
	admin = User.create!(:name => "Susie Carmichael",   #if reset DB, first user as admin
		         :email	=> "susie@nick.com",
				 :password => "nickT00ns",
				 :password_confirmation => "nickT00ns")
	admin.toggle!(:admin) # set to true

	100.times do |n|
		name     = Faker::Name.name
		email    = "holla#{n+1}@bueno.jp"
		password = "como#{n}estas"
		User.create!(:name => name,
					 :email => email,
					 :password => password,
					 :password_confirmation => password)				
	end
end

def make_microposts
	
	User.all(:limit => 10).each do |user| #limit to 10 users
		50.times do
			user.microposts.create!(:content => Faker::Lorem.sentence(5) )
		end
	end
end

def make_relationships
	users = User.all 
	user = users.first
	following = users[1..50] #first user follows the next 50
	followers = users[3..40]  #users 4-41 follow first user
	following.each { |followed| user.follow!(followed) }  #
	followers.each { |follower| follower.follow!(user) }  #...what kind of syntax is this?
end