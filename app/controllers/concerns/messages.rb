module Concerns
  module Messages
    def login_message
      "Your token expires in 3 hours time!"
    end

    def logout_message
      "You are now logged out!"
    end

    def not_authorized_message
      "You are not authorized!"
    end
  end
end