
def sign_in(user)
  visit sign_in_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_in_as(name, password)
	@user = User.new(
  					name: "Example User123", 
  					email: "example123@example.com",
  					password: "12345678",
  					password_confirmation: "12345678")
  visit sign_in_path
  fill_in "Email",    with: @user.name
  fill_in "Password", with: @user.password
  click_button "Sign in"
end