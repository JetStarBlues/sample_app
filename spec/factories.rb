Factory.define :user do |user|
	user.name				   "exampleUser"
	user.email				   "user@example.com"
	user.password  			   "superSecret"
	user.password_confirmation "superSecret"
end