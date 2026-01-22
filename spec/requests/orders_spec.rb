require "rails_helper"

RSpec.describe "Orders API", type: :request do
  
  describe "POST /orders" do
    let!(:show) { create(:show, total_inventory: 100, sold_inventory: 0) }
    
    let(:valid_params) do
      {
        customer_email: "test@example.com",
        items: [
          { show_id: show.id, quantity: 2 }
        ]
      }
    end
    
    context "with valid parameters" do
      it "creates an order" do
        expect {
          post "/orders", params: valid_params
        }.to change(Order, :count).by(1)
      end
      
      it "creates order items" do
        expect {
          post "/orders", params: valid_params
        }.to change(OrderItem, :count).by(1)
      end
      
      it "updates show inventory" do
        post "/orders", params: valid_params
        
        show.reload
        expect(show.sold_inventory).to eq(2)
      end
      
      it "returns 201 created" do
        post "/orders", params: valid_params
        expect(response).to have_http_status(:created)
      end
    end
    
    context "with invalid email" do
      it "returns 422 with errors" do
        invalid_params = valid_params.merge(customer_email: "invalid")
        
        post "/orders", params: invalid_params
        
        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include("Invalid email address")
      end
    end
    
    context "with insufficient inventory" do
      it "returns 422 with errors" do
        invalid_params = valid_params.merge(
          items: [{ show_id: show.id, quantity: 200 }]
        )
        
        post "/orders", params: invalid_params
        
        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json["errors"]).to include(/Insufficient inventory/)
      end
    end
  end
  
  describe "GET /orders/:id" do
    let(:order) { create(:order) }
    let!(:item) { create(:order_item, order: order) }
    
    it "returns the order with items" do
      get "/orders/#{order.id}"
      
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(order.id)
      expect(json["order_items"]).to be_present
    end
  end
end
