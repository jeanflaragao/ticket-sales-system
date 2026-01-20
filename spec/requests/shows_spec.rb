require "rails_helper"

RSpec.describe "Shows API", type: :request do
  
  describe "GET /shows" do
    let!(:shows) { create_list(:show, 3) }
    
    before { get "/shows" }
    
    it "returns HTTP success" do
      expect(response).to have_http_status(:success)
    end
    
    it "returns all shows" do
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
  
  describe "GET /shows/:id" do
    let(:show) { create(:show) }
    
    before { get "/shows/#{show.id}" }
    
    it "returns HTTP success" do
      expect(response).to have_http_status(:success)
    end
    
    it "returns the show" do
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(show.id)
      expect(json["name"]).to eq(show.name)
    end
  end
  
  describe "POST /shows" do
    let(:valid_attributes) do
      {
        show: {
          name: "Hamilton",
          total_inventory: 100,
          price: 150.00
        }
      }
    end
    
    context "with valid parameters" do
      it "creates a new show" do
        expect {
          post "/shows", params: valid_attributes
        }.to change(Show, :count).by(1)
      end
      
      it "returns 201 created" do
        post "/shows", params: valid_attributes
        expect(response).to have_http_status(:created)
      end
    end
    
    context "with invalid parameters" do
      it "does not create a show" do
        expect {
          post "/shows", params: { show: { name: "" } }
        }.not_to change(Show, :count)
      end
      
      it "returns 422 unprocessable entity" do
        post "/shows", params: { show: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
