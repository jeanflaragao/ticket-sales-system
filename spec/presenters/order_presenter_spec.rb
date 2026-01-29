require 'rails_helper'
RSpec.describe OrderPresenter do
  subject { described_class.new(order.reload) }

  let(:order) { create(:order, customer_email: 'test@example.com') }
  let(:show) { create(:show, price: 150.00) }
  let!(:item) { create(:order_item, order: order, show: show, quantity: 2, price: 150.00) }

  describe '#as_json' do
    it 'includes customer info' do
      json = subject.as_json

      expect(json[:customer][:email]).to eq('test@example.com')
      expect(json[:customer][:order_count]).to be > 0
    end

    it 'includes items info' do
      json = subject.as_json

      expect(json[:items].length).to eq(1)
      expect(json[:items].first[:show_name]).to eq(show.name)
      expect(json[:items].first[:quantity]).to eq(2)
      expect(json[:items].first[:subtotal]).to eq(300.00)
    end

    it 'includes pricing info' do
      json = subject.as_json

      expect(json[:pricing][:subtotal]).to eq(300.00)
      expect(json[:pricing][:currency]).to eq('USD')
    end

    it 'includes status info' do
      json = subject.as_json

      expect(json[:status][:current]).to eq('pending')
      expect(json[:status][:can_cancel]).to be true
    end
  end
end
