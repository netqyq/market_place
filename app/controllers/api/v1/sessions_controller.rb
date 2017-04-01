class Api::V1::SessionsController < ApplicationController

  # login process.
  def create
    puts "==============="
    p params[:session]
    puts params[:session][:email]
    user_password = params[:session][:password]
    user_email = params[:session][:email]

    user = user_email.present? && User.find_by(email: user_email)
    puts "user: #{user}"

    if user.valid_password? user_password
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200, location: [:api, user]
    else
      render json: {errors: "Invalid email or password"}, status: 422
    end
  end


end
