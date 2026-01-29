require 'rails_helper'

RSpec.describe ShowSearchQuery do
  describe '#call' do
    let!(:cheap_show) do
      create(:show, name: 'Cheap Show', price: 50.00, total_inventory: 100, sold_inventory: 0)
    end
    let!(:expensive_show) do
      create(:show, name: 'Expensive Show', price: 300.00,
                    total_inventory: 100, sold_inventory: 100)
    end
    let!(:mid_show) do
      create(:show, name: 'Mid Show', price: 150.00, total_inventory: 100, sold_inventory: 50)
    end

    it 'filters by availability' do
      results = described_class.new.call(available: 'true')

      expect(results).to include(cheap_show, mid_show)
      expect(results).not_to include(expensive_show)
    end

    it 'filters by price range' do
      results = described_class.new.call(min_price: 100, max_price: 200)

      expect(results).to include(mid_show)
      expect(results).not_to include(cheap_show, expensive_show)
    end

    it 'searches by name' do
      results = described_class.new.call(search: 'cheap')

      expect(results).to include(cheap_show)
      expect(results).not_to include(mid_show, expensive_show)
    end

    it 'sorts by price' do
      results = described_class.new.call(sort: 'price_low')

      expect(results.first).to eq(cheap_show)
      expect(results.last).to eq(expensive_show)
    end

    it 'combines multiple filters' do
      results = described_class.new.call(
        available: 'true',
        min_price: 100,
        max_price: 200
      )

      expect(results).to include(mid_show)
      expect(results).not_to include(cheap_show, expensive_show)
    end
  end
end
