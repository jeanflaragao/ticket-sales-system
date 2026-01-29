FactoryBot.define do
  factory :order do
    sequence(:customer_email) { |n| "customer#{n}@example.com" }
    status { 'pending' }
    total { 0.0 }

    trait :confirmed do
      status { 'confirmed' }
    end

    trait :cancelled do
      status { 'cancelled' }
    end

    factory :order_with_items do
      transient do
        items_count { 2 }
      end

      after(:create) do |order, evaluator|
        create_list(:order_item, evaluator.items_count, order: order)
        order.update!(total: order.order_items.sum { |i| i.price * i.quantity })
      end
    end
  end
end
