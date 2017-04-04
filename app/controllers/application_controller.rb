class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  
  include Authenticable

  protected

    def pagination(paginated_array, per_page)
      { pagination: { per_page: per_page.to_i,
                      total_pages: paginated_array.total_pages,
                      total_objects: paginated_array.total_count } }
    end
end
