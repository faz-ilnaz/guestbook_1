require 'spec_helper'

describe "UserPages" do
	subject { page }

	

	describe "signup page" do
		before { visit new_user_registration_path }

		it { should have_selector('h2',    text: 'Sign up') }
		it { should have_selector('title', text: 'Sign up') }


		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
				
			end

			describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
				it { should have_content('error') }
				it { should have_content("Name can't be blank") }
				it { should have_content("Email can't be blank") }
				it { should have_content("Password can't be blank") }
      end

      describe "with invalid password confirmation" do
      	before do
					fill_in "Name",         with: "Example User"
					fill_in "Email",        with: "example1@example.com"
					fill_in "Password",     with: "12345678"
					fill_in "Password confirmation", with: ""
					click_button submit
				end

				it { should have_content(
					 	"Password confirmation doesn't match Password") }
    	end
		end

		describe "with valid information" do
			before do
				fill_in "Name",         with: "Example User"
				fill_in "Email",        with: "example1@example.com"
				fill_in "Password",     with: "12345678"
				fill_in "Password confirmation", with: "12345678"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('example@example.com') }

        it { should have_selector(
        	'div.alert', text: 'Welcome!') }
      end

		end
	end

	describe "signin page" do
    before { visit new_user_session_path }

    it { should have_selector('h2',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }

    describe "signin" do
	    before { visit new_user_session_path }

	    describe "with invalid information" do
	      before { click_button "Sign in" }

	      it { should have_selector('title', text: 'Sign in') }
	      it { should have_selector('div.alert.alert', text: 'Invalid') }

	      describe "after visiting another page" do
				  before { click_link "guest book" }
				  it { should_not have_selector('div.alert.alert-notice') }
				end
	    end

	    describe "with valid information" do
	      let(:user) { FactoryGirl.create(:user) }
	      before do
	        fill_in "Email",    with: user.email.upcase
	        fill_in "Password", with: user.password
	        click_button "Sign in"
	      end

	      it { should have_selector('title', text: 'Guest book') }
	      it { should have_link('Profile', href: edit_user_registration_path) }
	      it { should have_link('Sign out', href: destroy_user_session_path) }
	      it { should_not have_link('Sign in', href: new_user_session_path) }

	      describe "followed by signout" do
	        before { click_link "Sign out" }
	        it { should have_link('Sign in') }
	      end
	    end

	    describe "authorization" do

		    describe "for non-signed-in users" do
		      let(:user) { FactoryGirl.create(:user) }

		      # describe "when attempting to visit a protected page" do
		      #   before do
		      #     visit edit_user_registration_path
		      #     fill_in "Email",    with: user.email
		      #     fill_in "Password", with: user.password
		      #     click_button "Sign in"
		      #   end

		      #   describe "after signing in" do

		      #     it "should render the desired protected page" do
		      #       page.should have_selector('title', text: 'Guest book')
		      #     end
		      #   end
		      # end

		      describe "in the Users controller" do

		        describe "visiting the edit page" do
		          before { visit edit_user_registration_path }
		          it { should have_selector('title', text: 'Sign in') }
		        end

		        describe "submitting to the update action" do
		          before { put '/users' }
		          specify { response.should redirect_to(new_user_session_path) }
		        end
		      end
		    end

		    # describe "as wrong user" do
		    #   let(:user) { FactoryGirl.create(:user) }
		    #   let(:wrong_user) { FactoryGirl.create(:user, 
		    #   											name: "Wrong User",
		    #   											email: "wrong@example.com") }
		    #   before {
		    #   	visit new_user_session_path
		    #   	fill_in "Email",    with: user.email.upcase
	     #    	fill_in "Password", with: user.password
	     #    	click_button "Sign in" }

		      
		    # end
		  end
	  end
  end

  describe "edit profile page" do

		before { visit new_user_session_path }
    let(:user) { FactoryGirl.create(:user) }

    # sign_in(:user)
    before do
	    fill_in "Email",    with: user.email
	    fill_in "Password", with: user.password
	    click_button "Sign in"
	  end

    before { visit edit_user_registration_path }

    describe "with valid information" do
    	before { visit edit_user_registration_path }
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Current password",         with: user.password
        click_button "Update"
      end

      it { should have_selector('div.alert.alert-notice') }
      it { should have_link('Sign out', href: destroy_user_session_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

    describe "page" do
      it { should have_selector('h2',    text: "Edit User") }
      it { should have_selector('title', text: "Edit User") }
    end

    describe "with invalid information" do
      before { click_button "Update" }

      it { should have_content('error') }
    end

    
  end

end
