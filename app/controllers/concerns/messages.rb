module Concerns
  module Messages
    def login_message
      "Your token expires in 3 hours time!"
    end

    def invalid_login_message
      "Invalid email or password!"
    end

    def logout_message
      "You are now logged out!"
    end

    def not_authorized_message
      "You are not authorized!"
    end

    def delete_message
       "#{controller_name.singularize.capitalize} has been deleted"
    end

    def not_permitted_message
      "This #{controller_name.singularize} cannot be found"
    end

    def not_permitted
      render json: { error: not_permitted_message }, status: 403
    end

    def create_error
      "Bucketlist not saved"
    end

    def update_error
      "Bucketlist not updated"
    end

  end
end