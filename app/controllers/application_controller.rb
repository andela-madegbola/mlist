class ApplicationController < ActionController::API
  require 'json_web_token'
  include Concerns::Messages

  before_action :authenticate_request, except: [:no_route]

  def no_route
    render json: { error: no_route_message }, status: 404
  end

  private

  def authenticate_request
    return token_not_authorized unless decode_auth_header.class.name == "User"
    @current_user = decode_auth_header
  end

  def token_not_authorized
    render json: { error: not_authorized_message }, status: 401
  end

  def decode_auth_header
    return nil unless request.headers["Authorization"].present?
    header_token = request.headers["Authorization"].split(" ").last
    decode_auth_token ||= JsonWebToken.decode(header_token)
    @user ||= User.find_by(id: decode_auth_token[:user_id]) if decode_auth_token
    @user if @user && (@user.serial_no == decode_auth_token[:serial_no])
  end
end
