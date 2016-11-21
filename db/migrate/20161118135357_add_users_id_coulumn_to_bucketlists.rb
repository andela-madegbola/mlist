class AddUsersIdCoulumnToBucketlists < ActiveRecord::Migration[5.0]
  def change
    add_column :bucketlists, :user_id, :integer
    add_index :bucketlists, :user_id
  end
end
