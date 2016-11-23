class Item < ApplicationRecord
  extend Paginate

  belongs_to :bucketlist
  before_create :status
  validates :name,  presence: true
  validates :bucketlist_id,  presence: true

  private

  def status
    self.done ||= 0
  end
end
