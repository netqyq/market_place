require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do

  describe "GET #index" do
    before(:each) do 
      current_user = FactoryGirl.create :user 
      api_authorization_header current_user.auth_token
      4.times { FactoryGirl.create :order, user: current_user }
      get :index, params: { user_id: current_user.id }
    end

    it "returns 4 order records from the user" do
      orders_response = json_response
      items_num = orders_response.size
      expect(items_num).to eq 4
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do 
      current_user = FactoryGirl.create :user 
      api_authorization_header current_user.auth_token
      @order = FactoryGirl.create :order, user: current_user
      get :show, params: { user_id: current_user.id, id: @order.id }
    end

    it "returns the order" do
      order_response = json_response
      expect(order_response[:id]).to eq @order.id
    end

    it { should respond_with 200 }

  end

  describe "POST #create" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token

      product_1 = FactoryGirl.create :product, user: current_user
      product_2 = FactoryGirl.create :product, user: current_user
      order_params = { product_ids: [product_1.id, product_2.id] }
      post :create, params: { user_id: current_user.id, order: order_params } 
    end

    it "returns the just user order record" do
      order_response = json_response
      puts "=======response========="
      p order_response
      expect(order_response[:id]).to be_present
    end

    it "should respond_with 201 " do 
      puts "begin it ==============="
      should respond_with 201 
    end
  end

  describe '#set_total!' do
    before(:each) do 
      current_user = FactoryGirl.create :user 
      api_authorization_header current_user.auth_token
      product_1 = FactoryGirl.create :product, user: current_user, price: 30
      product_2 = FactoryGirl.create :product, user: current_user, price: 50
      @order = FactoryGirl.build :order, product_ids: [product_1.id, product_2.id]
    end

    it "returns the total amount to pay for the products" do
      expect(@order.set_total!).to eq 80  
    end
  end

end
