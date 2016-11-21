class Bucketlist < ApplicationRecord
  extend Paginate

  belongs_to :user

  scope :search, lambda { |name_query|
    where("lower(name) LIKE ?", "%#{name_query.downcase if name_query}%")
  }
end
