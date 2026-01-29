FactoryBot.define do
  factory :order_item do
    association :order
    association :show
    quantity { 2 }
    price { 150.00 }

    trait :single do
      quantity { 1 }
    end

    trait :bulk do
      quantity { 10 }
    end
  end
end
