require 'faker'

namespace :db do
	desc "Fill database with sample users"
	task :populate => :environment do  # :populate > name of task. To call, 'rake db:populate'
									   # :environment > load Rails environment
		#Rake::Task['db:reset'].invoke  #resets database
		User.create!(:name => "glam20",  #if reset DB, this would be user whose info we know
			         :email	=> "glam20@fab.com",
					 :password => "glamtastic",
					 :password_confirmation => "glamtastic")
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