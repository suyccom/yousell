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

  factory :product_type, class: ProductType do
    name 'Zapatillas Lewis'
  end

  factory :provider, class: Provider do
    name 'Bad Provider'
    code 'BP'
  end

  factory :product, class: Product do
    price 10
    amount 5
    provider_code 'ZZ11'
    association :product_type
    association :provider
  end

  factory :line, class: Line do
    association :product
  end

  factory :sale, class: Sale do
    after(:create) do |sale, evaluator|
      FactoryGirl.create(:line, :sale => sale)
      sale.update_attribute(:complete, true)
    end
  end
end



