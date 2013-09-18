require 'faker'

namespace :db do
	desc "Fill database with sample users"
	task :populate => :environment do  # :populate > name of task. To call, 'rake db:populate'
									   # :environment > load Rails environment
		#Rake::Task['db:reset'].invoke  #resets database
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
end