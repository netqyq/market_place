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

    it "has the user as a embeded object" do
      product_response = json_response
      expect(product_response[:user][:email]).to eql @product.user.email
    end

    it { should respond_with 200}
  end

  describe "GET #index" do
    context "when is not receiving any product_ids parameter" do
      before(:each) do 
        2.times { FactoryGirl.create :product }
        get :index
      end
      it "get products list" do
        products_response = json_response
        products_size = products_response.size
        expect(products_size).to eq(2)
      end

      it "returns the user object into each product" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end

      # for the pagination
      
      it { 
        expect(json_response).to have_key(:meta) 
      }
      it { expect(json_response[:meta]).to have_key(:pagination) }
      it { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
      it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
      it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }

      it { should respond_with 200}
    end

    context "when product_ids parameter is sent" do
      before(:each) do
        @user = FactoryGirl.create :user
        3.times { FactoryGirl.create :product, user: @user }
        get :index, params: {product_ids: @user.product_ids}
      end

      it "returns just the products that belong to the user" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eql @user.email
        end
      end
    end
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product 
        api_authorization_header user.auth_token
        post :create, params: {user_id: user.id, product: @product_attributes}
      end

      it "receive json response of just created product" do
        product_response = json_response
        expect(product_response[:title]).to eq @product_attributes[:title]  
      end

      it {should respond_with 201}
    end 

    context "when is not created" do
      before(:each) do 
        user = FactoryGirl.create :user 
        @invalid_product_attributes = {title: "this is title", price: "Twelve dollars"}
        api_authorization_header user.auth_token
        post :create, params: {user_id: user.id, product: @invalid_product_attributes}
      end

      it "receive error json response" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include("is not a number")
      end

      it {should respond_with 422}

    end
  end

  describe "PUT #update" do
    before(:each) do 
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        put :update, params: { user_id: @user.id, id: @product.id, product: {title: "updated title" } }
      end

      it "receive json response of just updated product" do
        product_response = json_response
        expect(product_response[:title]).to eq "updated title"
      end

      it {should respond_with 200}
    end 

    context "when is not updated" do
      before(:each) do 
        put :update, params: { user_id: @user.id, id: @product.id, product: {price: "twenty dollars" } }
      end

      it "receive error json response" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include("is not a number")
      end

      it {should respond_with 422}

    end
  end

  describe "DELETE #destroy" do
    before do 
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, params: {user_id: @user.id, id: @product.id}
    end

    it { should respond_with 204}
  end


end
