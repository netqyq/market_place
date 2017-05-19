module Api
  module V1
    class OrdersController < ApplicationController
      before_action :authenticate_with_token!

      respond_to :json

      def index
        orders = Order.where(user: current_user)
                      .page(params[:page]).per(params[:per_page])
        logger.debug orders
        render json: orders, :adapter => :json,
                     :meta => pagination(orders, params[:per_page])
      end

      def show
        order = current_user.orders.find(params[:id])
        render json: order
      end

      def create
        order = current_user.orders.build(order_params)

        if order.save
          order.reload
          #we reload the object so the response displays the product objects
          #OrderMailer.send_confirmation(order).deliver_later
          OrderMailer.delay.send_confirmation(order)
          render json: order, status: 201, location: [:api, current_user, order]
        else
          render json: { errors: order.errors }, status: 422
        end
      end

    private

      def order_params
        params.require(:order).permit(product_ids: [])
      end

    end
  end
end
