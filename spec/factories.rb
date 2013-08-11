FactoryGirl.define do
  factory :user do
    name     "Example User"
    email    "example@example.com"
    password "12345678"
    password_confirmation "12345678"
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end