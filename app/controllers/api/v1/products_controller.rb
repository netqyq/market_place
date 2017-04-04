class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]
  respond_to :json
  
  def show
    # why this is error here, but ok in users_controller
    #respond_with Product.find(params[:id])

    # replace respond_with to below
    product = Product.find(params[:id])
    render json: product, status: 200
  end

  def index
    products = Product.search(params).page(params[:page]).per(params[:per_page])
    #logger.debug products
    render json: products, adapter: :json, meta: { pagination:
                                   { per_page: params[:per_page],
                                     total_pages: products.total_pages,
                                     total_objects: products.total_count } }
  end

  def create
    product = current_user.products.build(product_params)
    if product.save
      render json: product, status: 201, location: [:api, product]
    else
      render json: {errors: product.errors}, status: 422
    end
  end

  def update
    product = current_user.products.find(params[:id])
    if product.update(product_params)
      render json: product
    else
      render json: {errors: product.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    product = current_user.products.find(params[:id])
    product.destroy
    head 204
  end

  def pagination_dict(collection)
    {
      per_page: collection.per_page,
      total_pages: collection.total_pages,
      total_objects: collection.total_count
    }
  end


  private

    def product_params
      params.require(:product).permit(:title, :price, :published)
    end

end
