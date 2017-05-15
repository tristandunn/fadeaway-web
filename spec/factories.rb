FactoryGirl.define do
  factory :discount do
    name   "Example"
    amount 2_50
  end

  factory :order do
    association :user

    sequence :remote_id

    email
    amount     20_00
    card_token "tok_1234"
  end

  factory :refund do
    association :order

    sequence :remote_id

    amount     5_00
    created_at { Time.zone.now }
  end

  factory :release do
    description "Initial release."
    version     "0.1.0"
    released_at { Time.zone.now }
  end

  factory :user do
    sequence :remote_id

    name "Sue"
  end

  sequence :email do |n|
    "order-#{n}@example.com"
  end
end
