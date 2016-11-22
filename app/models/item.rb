class Item < ApplicationRecord
  belongs_to :bucketlist

  before_create :status

  private

  def status
    self.done ||= 0
  end
end
