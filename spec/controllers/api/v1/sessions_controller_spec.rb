require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe "POST #create" do
    
    before(:each) do 
      @user = FactoryGirl.create :user
    end

    context "when the credentials are correct" do
      before(:each) do 
        credentials = { email: @user.email, password: "12345678"}
        post :create, params: { session: credentials }
      end

      it "returns the user record corresponding to the given credentials " do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end
      
      it { should respond_with 200}

      it "should login in" do
        expect(subject.current_user).to_not eq(nil)
      end

    end

    context "when the credentials are incorrect" do
      before(:each) do
        credentials = { email: @user.email, password: "invalidpassword" }
        post :create, params: { session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eql "Invalid email or password"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do 
      @user = FactoryGirl.create :user
      sign_in @user
      delete :destroy, params: {id: @user.auth_token}
    end

    it { should respond_with 204 }

    it "current_user is nil" do
      expect(subject.current_user).to eq(nil)
    end

  end




end
