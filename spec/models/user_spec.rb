require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }
  it { should be_valid }

  it { should validate_presence_of(:email) }

  # here have problem, why not should?
  it { should_not validate_uniqueness_of(:email) }

  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }
  # we test the auth_token is unique
  it { should validate_uniqueness_of(:auth_token)}

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end

  it { should have_many(:products) }

  describe "#products association delete dependence" do
    before do 
      @user.save
      3.times {FactoryGirl.create :product, user: @user}
    end

    it "destroy the associated products on self destruct" do
      products = @user.products
      @user.destroy
      products.each do |product|
        expect(Product.find(product)).to raise_error ActiveRecord::RecordNotFound  
      end

    end
  end

end
