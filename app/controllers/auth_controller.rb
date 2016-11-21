class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login]

  def login
    return invalid_credentials_detected unless authenticate_user
    payload = {
      user_id: authenticate_user.id,
      serial_no: authenticate_user.serial_no
    }
    user_token = JsonWebToken.encode(payload)
    render json: { auth_token: user_token, message: login_message }
  end

  def logout
    if @current_user.update_attribute(:serial_no, rand(100..999).to_s)
      render json: { message: logout_message }
    end
  end

  private

  def login_params
    params[:email].downcase! if params[:email]
    params.permit(:email, :password)
  end

  def authenticate_user
    @user = User.find_by(email: login_params[:email])
    @user.authenticate(login_params[:password]) if @user
  end

  def invalid_credentials_detected
    render json: { error: invalid_login_message }, status: 401
  end
end

