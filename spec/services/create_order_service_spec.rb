require 'rails_helper'

RSpec.describe CreateOrderService do
  describe '#call' do
    let(:show) { create(:show, total_inventory: 100, sold_inventory: 0) }
    
    let(:valid_params) do
      {
        customer_email: 'test@example.com',
        items: [
          { show_id: show.id, quantity: 2 }
        ]
      }
    end
    
    context 'with valid params' do
      it 'creates an order' do
        service = described_class.new(valid_params)
        
        expect {
          service.call
        }.to change(Order, :count).by(1)
      end
      
      it 'creates order items' do
        service = described_class.new(valid_params)
        
        expect {
          service.call
        }.to change(OrderItem, :count).by(1)
      end
      
      it 'updates show inventory' do
        service = described_class.new(valid_params)
        service.call
        
        show.reload
        expect(show.sold_inventory).to eq(2)
      end
      
      it 'returns success' do
        service = described_class.new(valid_params)
        result = service.call
        
        expect(result.success?).to be true
        expect(result.order).to be_persisted
      end
    end
    
    context 'with invalid email' do
      it 'returns errors' do
        params = valid_params.merge(customer_email: 'invalid')
        service = described_class.new(params)
        result = service.call
        
        expect(result.success?).to be false
        expect(result.errors).to include('Invalid email address')
      end
    end
    
    context 'with insufficient inventory' do
      it 'returns errors' do
        params = valid_params.merge(
          items: [{ show_id: show.id, quantity: 200 }]
        )
        service = described_class.new(params)
        result = service.call
        
        expect(result.success?).to be false
        expect(result.errors).to include(/Insufficient inventory/)
      end
    end
  end
end