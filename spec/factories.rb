# encoding: utf-8

FactoryGirl.define do
  factory :warehouse, class: Warehouse do
    name {"#{Faker::Name.last_name} #{(rand(99-11) + 11)}"}
  end
  
  factory :user, class: User do
    name {Faker::Name.first_name}
    email_address {Faker::Internet.email}
    password 'RobotRobot'
    password_confirmation 'RobotRobot'
  end
end



