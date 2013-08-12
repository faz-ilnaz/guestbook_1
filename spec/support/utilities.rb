
def sign_in(user)
  visit sign_in_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_in_as(name, password)
  visit sign_in_path
  fill_in "Email",    with: name
  fill_in "Password", with: password
  click_button "Sign in"
end