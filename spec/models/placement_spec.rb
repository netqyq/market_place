require 'rails_helper'

RSpec.describe Placement, type: :model do
  let(:placement) { FactoryGirl.build :placement }
  subject { placement }

  it { should respond_to :order_id }
  it { should respond_to :product_id }

  it { should belong_to :order }
  it { should belong_to :product }

  it { should respond_to :product_id }
  it { should respond_to :quantity }


  describe "#decrement_product_quantity!" do
    it "decreases the product quantity by the placement quantity" do
      #product = placement.product
      product = FactoryGirl.create :product, quantity: 5
      order = FactoryGirl.create :order
      placement = FactoryGirl.create :placement, product: product, order: order, quantity: 2
      
      expect{placement.decrement_product_quantity!}.to change{product.quantity}.by(-placement.quantity)
    end
  end
end
