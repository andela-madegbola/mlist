class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, except: [:create]

  def create
    @user = User.new(user_params)
    return create_error unless @user.save
    render json: @user
  end

  def destroy
    render json: { message: delete_message } if @user.destroy
  end

  private

  def set_user
    @user = @current_user
  end

  def user_params
    params.permit(:email,
                  :username,
                  :password,
                  :password_confirmation
                  )
  end
end
