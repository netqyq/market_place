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
      orders_response = json_response[:orders]
      items_num = orders_response.size
      expect(items_num).to eq 4
    end

    # test the pagination
    it { expect(json_response).to have_key(:meta) }
    it { expect(json_response[:meta]).to have_key(:pagination) }
    it { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }


    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do 
      current_user = FactoryGirl.create :user 
      api_authorization_header current_user.auth_token

      @product = FactoryGirl.create :product
      @order = FactoryGirl.create :order, user: current_user, product_ids: [@product.id]
      get :show, params: { user_id: current_user.id, id: @order.id }
    end

    it "returns the order" do
      order_response = json_response
      expect(order_response[:id]).to eq @order.id
    end

    it "includes the total of order" do
      expect(json_response[:total]).to eql @order.total.to_s
    end

    it "includes the products in the order" do
      products_response = json_response[:products]
      expect(products_response[0][:title]).to eql @product.title 
    end

    it { should respond_with 200 }

  end

  describe "POST #create" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token

      product_1 = FactoryGirl.create :product, user: current_user
      product_2 = FactoryGirl.create :product, user: current_user
      order_params = { product_ids_and_quantities: [[product_1.id, 2],[ product_2.id, 3]] }
      post :create, params: { user_id: current_user.id, order: order_params } 
    end

    it "returns the just user order record" do
      order_response = json_response
      expect(order_response[:id]).to be_present
    end

    it "should respond_with 201 " do 
      should respond_with 201 
    end
  end



end
