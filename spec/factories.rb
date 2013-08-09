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
    name '300'
  end

  factory :provider, class: Provider do
    name 'Bad Provider'
    code {"BP#{(rand(99-11) + 11)}"}
  end

  factory :product, class: Product do
    price 10
    association :product_type
    association :provider
    after(:create) do |product, evaluator|
      product.product_warehouses.first.update_attribute(:amount, 10)
    end
  end
  
  factory :product_warehouse, class: ProductWarehouse do
    amount 10
  end

  factory :line, class: Line do
  end

  factory :sale, class: Sale do
    after(:create) do |sale, evaluator|
      product = FactoryGirl.create(:product)
      FactoryGirl.create(:line, :sale => sale, :product => product)
      sale.update_attribute(:complete, true)
    end
  end
end



