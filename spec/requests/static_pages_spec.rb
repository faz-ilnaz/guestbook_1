require 'spec_helper'

describe "Static pages" do
  subject {page}

  describe "Home page" do
    before { visit root_path }
    it { should have_selector('title' , text: 'Guest book') }

    # it "should have the title 'Home'" do
    #   visit '/static_pages/home'
    #   page.should have_selector('title',
    #                     :text => "Guest book | Home")
    # end

  end

  describe "signup page" do
    before { visit new_user_registration_path }

    it { should have_selector('h2', text: 'Sign up') }
    it { should have_selector('title', text: 'Sign up') }
  end
end