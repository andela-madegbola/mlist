class Bucketlist < ApplicationRecord
  extend Paginate

  has_many :items, dependent: :destroy
  belongs_to :user
  validates :name,  presence: true,
                    length: { maximum: 50 }

  scope :search, -> (name) {
    name = name.downcase if name
    where("lower(name) like ?", "%#{name}%")
  }
end
