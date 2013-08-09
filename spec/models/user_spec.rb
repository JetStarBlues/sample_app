require 'spec_helper'

describe User do

  before(:each) do
  	@var = {
      :name => "exampleUser", 
      :email => "user@example.com",
      :password => "superSecret",
      :password_confirmation => "superSecret"
    }
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

#Lesson 40
  describe "passwords" do

    before(:each) do
      #further simplification
      @user = User.new(@var)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end

  end

  describe "password validations" do

    it "should require a password" do
      User.new(@var.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@var.merge(:password_confirmation => "invalid")).
      should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      User.new(@var.merge(:password => short, :password_confirmation => short)).
      should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      User.new(@var.merge(:password => long, :password_confirmation => long)).
      should_not be_valid
    end

  end

  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@var)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end


  end

end