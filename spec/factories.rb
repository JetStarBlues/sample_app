Factory.define :user do |user|
	user.name				   "exampleUser"
	user.email				   "user@example.com"
	user.password  			   "superSecret"
	user.password_confirmation "superSecret"
end

Factory.sequence :email do |n|
	"holla#{n}@example.com"
end

Factory.define :micropost do |micropost|
	micropost.content		"Filler text"
	micropost.association   :user
end