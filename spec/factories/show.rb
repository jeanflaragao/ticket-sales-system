FactoryBot.define do
  factory :show do
    sequence(:name) { |n| "Show #{n}" }
    total_inventory { 100 }
    reserved_inventory { 0 }
    sold_inventory { 0 }
    price { 150.00 }

    # Traits (variations)
    trait :sold_out do
      total_inventory { 100 }
      sold_inventory { 100 }
    end

    trait :low_inventory do
      total_inventory { 100 }
      sold_inventory { 95 }
    end

    trait :expensive do
      price { 500.00 }
    end

    # Factory with association
    factory :show_with_orders do
      transient do
        orders_count { 3 }
      end

      after(:create) do |show, evaluator|
        create_list(:order_with_items, evaluator.orders_count, shows: [show])
      end
    end
  end
end
