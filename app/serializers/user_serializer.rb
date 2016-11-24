class UserSerializer < ActiveModel::Serializer
  include SerializerHelper

  attributes :id, :username, :email, :date_modified
end
