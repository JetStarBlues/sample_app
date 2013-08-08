require 'spec_helper'

describe User do

  before(:each) do
  	@var = {:name => "exampleUser", :email => "user@example.com"}
  end

  #Lesson 36 @7:00
  it "should create a new instance given a valid attribute" do
  	User.create!(@var)
  end

  it "should require a name" do
  	#replace 'exampleUser' with blank
  	noNameUser = User.new(@var.merge(:name => ""))
  	noNameUser.should_not be_valid
  end

  it "should require an email address" do
  	noNameUser = User.new(@var.merge(:email => ""))
  	noNameUser.should_not be_valid
  end

  it "should reject names that are too long" do
  	longName = "a" * 51
  	longNameUser = User.new(@var.merge(:name => longName))
  	longNameUser.should_not be_valid
  end

 #by no means robust...(domains,length,@symbol ...see user.rb 'email_regex')
  it "should accept valid email address" do
  	addr = %w[diamond@casino.com spades@casino.org queen.hearts@casino.uk queen-hearts@casino.uk spades@2casino.org spades@2_casino.org]
  	addr.each do |addr|
  		validEmailUser = User.new(@var.merge(:email => addr))
  		validEmailUser.should be_valid
  	end
  end
 #by no means robust...(typos...abc@aol.orgg)
  it "should reject invalid email address" do
  	addr = %w[diamond@casino,com spades@a.com]
  	addr.each do |addr|
  		invalidEmailUser = User.new(@var.merge(:email => addr))
  		invalidEmailUser.should_not be_valid
  	end
   end

  it "should reject duplicate emails" do
  	User.create!(@var)
  	userWithDuplicateEmail = User.new(@var)
  	userWithDuplicateEmail.should_not be_valid
  end

  it "should reject duplicate up to case" do
  	upperCaseEmail = "USER@ExamplE.COM"
  	User.create!(@var.merge(:email => upperCaseEmail))
  	userWithDuplicateEmail = User.new(@var)
  	userWithDuplicateEmail.should_not be_valid
  end

end
