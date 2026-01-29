require 'rails_helper'

RSpec.describe Orders::ValidateInventory do
  describe '.call' do
    let(:show) { create(:show, total_inventory: 100, sold_inventory: 0) }

    context 'with sufficient inventory' do
      it 'succeeds' do
        result = described_class.call(
          items: [{ show_id: show.id, quantity: 10 }]
        )

        expect(result).to be_success
      end
    end

    context 'with insufficient inventory' do
      it 'fails with error' do
        result = described_class.call(
          items: [{ show_id: show.id, quantity: 200 }]
        )

        expect(result).to be_failure
        expect(result.error).to include('Insufficient inventory')
      end
    end

    context 'with non-existent show' do
      it 'fails with error' do
        result = described_class.call(
          items: [{ show_id: 99_999, quantity: 1 }]
        )

        expect(result).to be_failure
        expect(result.error).to include('not found')
      end
    end
  end
end
