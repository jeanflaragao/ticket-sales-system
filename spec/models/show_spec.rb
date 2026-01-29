require 'rails_helper'

RSpec.describe Show, type: :model do
  describe 'validations' do
    subject { build(:show) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_numericality_of(:total_inventory).is_greater_than_or_equal_to(0) }

    describe 'custom validations' do
      it 'is invalid when reserved + sold exceeds total' do
        show = build(:show,
                     total_inventory: 100,
                     reserved_inventory: 60,
                     sold_inventory: 50)

        expect(show).not_to be_valid
        expect(show.errors[:base]).to include('Reserved + sold cannot exceed total inventory')
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:order_items) }
    it { is_expected.to have_many(:orders).through(:order_items) }
  end

  describe '#available_inventory' do
    it 'calculates available inventory correctly' do
      show = create(:show,
                    total_inventory: 100,
                    reserved_inventory: 20,
                    sold_inventory: 30)

      expect(show.available_inventory).to eq(50)
    end
  end

  describe '#sold_out?' do
    it 'returns true when no inventory available' do
      show = create(:show, :sold_out)
      expect(show).to be_sold_out
    end

    it 'returns false when inventory available' do
      show = create(:show, total_inventory: 100, sold_inventory: 50)
      expect(show).not_to be_sold_out
    end
  end

  describe '#percentage_sold' do
    it 'calculates percentage sold correctly' do
      show = create(:show, total_inventory: 100, sold_inventory: 75)
      expect(show.percentage_sold).to eq(75.0)
    end

    it 'returns 0 for zero total inventory' do
      show = create(:show, total_inventory: 0, sold_inventory: 0)
      expect(show.percentage_sold).to eq(0)
    end
  end
end
