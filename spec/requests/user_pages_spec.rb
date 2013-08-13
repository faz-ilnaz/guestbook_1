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
				before { sign_in user}

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

					describe "when attempting to visit a protected page" do
						before do
							visit edit_user_registration_path
							fill_in "Email",    with: user.email
							fill_in "Password", with: user.password
							click_button "Sign in"
						end

						describe "after signing in" do

							it "should render the desired protected page" do
								page.should have_selector('title', text: 'Edit User')
							end
						end
					end

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

					describe "in the Microposts controller" do

						describe "submitting to the create action" do
							before { post microposts_path }
							specify { response.should redirect_to(new_user_session_path) }
						end

						describe "submitting to the destroy action" do
							before { delete micropost_path(FactoryGirl.create(:micropost)) }
							specify { response.should redirect_to(new_user_session_path) }
						end
					end
				end

				describe "for signed-in users" do
					let(:user) { FactoryGirl.create(:user) }
					before do
						FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
						FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
						sign_in user
						visit root_path
					end

					it "should render microposts" do
						user.microposts.each do |micropost|
							page.should have_selector("li", text: micropost.content)
						end
					end
				end

				describe "as non-admin user" do
					let(:user) { FactoryGirl.create(:user) }
					let(:non_admin) { FactoryGirl.create(:user) }

					before { sign_in non_admin }

					describe "submitting a DELETE request to the Users#destroy action" do
						before { delete user_path(user) }
						specify { response.should redirect_to(new_user_session_path) }
					end
				end
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

	describe "home page" do
		let(:user) { FactoryGirl.create(:user) }
		before { sign_in user }
		let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
		let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

		before { visit root_path }

		describe "microposts" do
			it { should have_content(m1.content) }
			it { should have_content(m2.content) }
			it { should have_content(user.microposts.count) }
		end	
	end

	describe "users index page" do
		let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should_not have_selector('h1', text: 'All users') }
    it { should have_selector('title', text: 'Guest book') }

		describe "delete links" do
			let(:admin) { FactoryGirl.create(:admin) }

			describe "as an admin user" do
				
				before do
					visit destroy_user_session_path
					sign_in admin
					visit users_path
				end
				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect { click_link('delete') }.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: user_path(admin)) }
			end
		end

		describe "pagination" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				visit destroy_user_session_path
				sign_in admin
				visit users_path
			end
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
	end

end
