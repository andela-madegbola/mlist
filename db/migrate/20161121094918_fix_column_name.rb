class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :token, :serial_no
  end
end
