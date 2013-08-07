require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Guest book'" do
      visit '/static_pages/home'
      page.should have_content('Guest book')
    end

    # it "should have the title 'Home'" do
    #   visit '/static_pages/home'
    #   page.should have_selector('title',
    #                     :text => "Guest book | Home")
    # end

  end
end