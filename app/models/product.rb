class Product < ApplicationRecord
  belongs_to :user
  has_many :placements
  has_many :orders, through: :placements

  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 },
                    presence: true


  scope :filter_by_title, lambda {|keyword|
    where("lower(title) LIKE ?", "%#{keyword}%")
  }

  scope :above_or_equal_to_price, lambda { |price| 
    where("price >= ?", price) 
  }

  scope :below_or_equal_to_price, lambda { |price| 
    where("price <= ?", price) 
  }

  scope :recent, -> {
    order(:updated_at)
  }

  def self.search(params = {})
    products = params[:product_ids].present? ? Product.where(id: params[:product_ids]) : Product.all

    products = products.filter_by_title(params[:keyword]) if params[:keyword]
    products = products.above_or_equal_to_price(params[:min_price].to_f) if params[:min_price]
    products = products.below_or_equal_to_price(params[:max_price].to_f) if params[:max_price]
    products = products.recent(params[:recent]) if params[:recent].present?

    products
  end

  def self.cached_find(id)
    Rails.cache.fetch(['product', id], expires_in: 5.minutes) { find(id) }
  end

  after_commit :flush_cache

  private

    def flush_cache
      Rails.cache.delete(['product', id])
    end
end
