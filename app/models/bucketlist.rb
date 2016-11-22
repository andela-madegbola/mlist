class Bucketlist < ApplicationRecord
  extend Paginate

  has_many :items, dependent: :destroy
  belongs_to :user

  scope :search, lambda { |name_query|
    where("lower(name) LIKE ?", "%#{name_query.downcase if name_query}%")
  }
end
