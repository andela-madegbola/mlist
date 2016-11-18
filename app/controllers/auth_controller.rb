class AuthController < ApplicationController
   before_action :authenticate_request!, only: [:logout]

  def login
    user = User.find_by(email: params[:email].to_s.downcase)

    if user && user.authenticate(params[:password])
        auth_token = JsonWebToken.encode({user_id: user.id})
        user.update_attribute(:token, auth_token)
        render json: {auth_token: user.token}, status: :ok
    else
      render json: {error: 'Invalid username / password'}, status: :unauthorized
    end
  end

  def logout
    current_user.update_attribute(:token, nil)
    render json: { message: 'You have been logged_out' }
  end
end

