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


end
