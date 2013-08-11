require 'spec_helper'

describe Micropost do
	let(:user) { FactoryGirl.create(:user) }
	before { @micropost = user.microposts.build(content: "Lorem ipsum") }

	subject { @micropost }

	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should == user }

	it { should be_valid }

	describe "when user_id is not present" do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end

	describe "with blank content" do
		before { @micropost.content = " " }
		it { should_not be_valid }
	end

	describe "with content that is too long" do
		before { @micropost.content = "a" * 1501 }
		it { should_not be_valid }
	end

	describe "micropost associations" do
		
		before { user.save }
		let(:user) { FactoryGirl.create(:user) }
		let!(:older_micropost) do
			FactoryGirl.create(:micropost, user: user, created_at: 1.day.ago)
		end
		let!(:newer_micropost) do
			FactoryGirl.create(:micropost, user: user, created_at: 1.hour.ago)
		end

		# it "should have the right microposts in the right order" do
		# 	user.microposts.should == [newer_micropost, older_micropost]
		# end

		
	end
end