require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "GET #show" do
    before(:each) do 
      @product = FactoryGirl.create :product 
      get :show, params: {id: @product.id}
    end

    it "get the corresponding product" do
      product_response = json_response
      expect(product_response[:title]).to eql @product.title  
    end

    it { should respond_with 200}
  end

  describe "GET #index" do
    before(:each) do 
      2.times { FactoryGirl.create :product }
      get :index
    end

    it "get products list" do
      products_response = json_response
      products_size = products_response.size
      expect(products_size).to eq(2)
    end

    it { should respond_with 200}
  end
end
