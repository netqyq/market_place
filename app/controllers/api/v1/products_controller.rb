class Api::V1::ProductsController < ApplicationController
  respond_to :json
  
  def show
    # why this is error here, but ok in users_controller
    #respond_with Product.find(params[:id])

    # replace respond_with to below
    product = Product.find(params[:id])
    render json: product, status: 200
  end

  def index
    products = Product.all
    render json: products, status: 200
  end

end
