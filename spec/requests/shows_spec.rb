require 'rails_helper'

RSpec.describe 'Shows API', type: :request do
  let(:json_headers) { { 'Content-Type' => 'application/json', 'Accept' => 'application/json' } }

  describe 'GET /shows' do
    let!(:shows) { create_list(:show, 3) }

    it 'returns HTTP success' do
      get '/shows', headers: json_headers
      expect(response).to have_http_status(:success)
    end

    it 'returns all shows' do
      get '/shows', headers: json_headers
      expect(JSON.parse(response.body).size).to eq(Show.count)
    end
  end

  describe 'GET /shows/:id' do
    let(:show) { create(:show) }

    it 'returns HTTP success' do
      get "/shows/#{show.id}", headers: json_headers
      expect(response).to have_http_status(:success)
    end

    it 'returns the show' do
      get "/shows/#{show.id}", headers: json_headers
      json = JSON.parse(response.body)

      expect(json['id']).to eq(show.id)
      expect(json['name']).to eq(show.name)
    end
  end

  describe 'POST /shows' do
    let(:valid_attributes) do
      {
        show: {
          name: "Test Show #{Time.current.to_i}",
          total_inventory: 100,
          price: 150.00
        }
      }.to_json
    end

    context 'with valid parameters' do
      it 'creates a new show' do
        expect do
          post '/shows', params: valid_attributes, headers: json_headers
        end.to change(Show, :count).by(1)
      end

      it 'returns 201 created' do
        post '/shows', params: valid_attributes, headers: json_headers
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a show' do
        expect do
          post '/shows',
               params: { show: { name: '' } }.to_json,
               headers: json_headers
        end.not_to change(Show, :count)
      end

      it 'returns 422 unprocessable entity' do
        post '/shows',
             params: { show: { name: '' } }.to_json,
             headers: json_headers

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
