class UsersController < ApplicationController
  authenticate_with_token!
end
