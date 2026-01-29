require 'rails_helper'

RSpec.describe 'Orders API', type: :request do
  let(:json_headers) { { 'Content-Type' => 'application/json', 'Accept' => 'application/json' } }

  describe 'POST /orders' do
    let!(:show) { create(:show, total_inventory: 100, sold_inventory: 0) }

    let(:valid_params) do
      {
        customer_email: 'test@example.com',
        customer_name: 'John Doe',
        payment_method: 'credit_card',
        items: [
          { show_id: show.id, quantity: 2 }
        ]
      }
    end

    context 'with valid parameters' do
      it 'creates an order' do
        expect do
          post '/orders', params: valid_params.to_json, headers: json_headers
        end.to change(Order, :count).by(1)
      end

      it 'creates order items' do
        expect do
          post '/orders', params: valid_params.to_json, headers: json_headers
        end.to change(OrderItem, :count).by(1)
      end

      it 'updates show inventory' do
        post '/orders', params: valid_params.to_json, headers: json_headers

        show.reload
        expect(show.sold_inventory).to eq(2)
      end

      it 'returns 201 created' do
        post '/orders', params: valid_params.to_json, headers: json_headers
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid email' do
      it 'returns 422 with errors' do
        invalid_params = valid_params.merge(customer_email: 'invalid')

        post '/orders', params: invalid_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json['errors']).to include('Customer email is invalid')
      end
    end

    context 'with insufficient inventory' do
      it 'returns 422 with errors' do
        invalid_params = valid_params.merge(
          items: [{ show_id: show.id, quantity: 200 }]
        )

        post '/orders', params: invalid_params.to_json, headers: json_headers

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json['errors']).to include(/Insufficient inventory/)
      end
    end
  end

  describe 'GET /orders/:id' do
    let(:order) { create(:order) }
    let!(:item) { create(:order_item, order: order) }

    it 'returns the order with items' do
      get "/orders/#{order.id}", headers: json_headers

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(order.id)
      expect(json['items']).to be_present
    end
  end
end
