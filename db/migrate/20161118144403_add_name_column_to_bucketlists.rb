class AddNameColumnToBucketlists < ActiveRecord::Migration[5.0]
  def change
    add_column :bucketlists, :name, :string
  end
end
