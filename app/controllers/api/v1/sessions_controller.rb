module Api
  module V1
    class SessionsController < ApplicationController
      # login process.
      def create
        user_password = params[:session][:password]
        user_email = params[:session][:email]
        user = user_email.present? && User.find_by(email: user_email)
        if user.valid_password? user_password
          sign_in user, store: false
          user.generate_authentication_token!
          user.save
          render json: user, status: 200, location: [:api, user]
        else
          render json: { errors: "Invalid email or password" }, status: 422
        end
      end

      def destroy
        user = User.find_by(auth_token: params[:id])
        # here is different with book's code,
        # see http://apionrails.icalialabs.com/book/chapter_five
        sign_out user
        head 204
      end
    end
  end
end