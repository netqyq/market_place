class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!

  respond_to :json

  def index
    render json: current_user.orders
  end

  def show
    order = current_user.orders.find(params[:id])
    render json: order    
  end

  def create
    order = current_user.orders.build(order_params)

    if order.save
      OrderMailer.send_confirmation(order).deliver_later
      render json: order, status: 201, location: [:api, current_user, order]
    else
      render json: { errors: order.errors }, status: 422
    end
  end

private

  def order_params
    params.require(:order).permit(:product_ids => [])
  end

end
