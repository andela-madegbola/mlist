class HomeController < ApplicationController
  require 'jsonwebtoken'

  before_filter :authenticate_request!
  def index
    render json: {'logged_in' => true}
  end
end
