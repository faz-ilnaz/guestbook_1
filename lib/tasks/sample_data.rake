namespace :db do
  desc "Add "
  task populate: :environment do
    admin = User.create!(name:                  "Admin",
                         email:                 "admin@example.com",
                         password:              "12345678",
                         password_confirmation: "12345678")
    admin.toggle!(:admin)
  end
end