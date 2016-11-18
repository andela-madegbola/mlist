class ApplicationController < ActionController::API
  require 'jsonwebtoken'

  def authenticate_request!
    unless payload && JsonWebToken.valid_payload(payload.first) && current_user.token
      return invalid_authentication
    end
    current_user
  end

  def invalid_authentication
    render json: {error: 'Invalid Request'}, status: :unauthorized
  end

  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token)
  rescue
    nil
  end

  def current_user
    @current_user = User.find_by(id: payload[0]['user_id'])
  end
end
