class AddStatusToOrders < ActiveRecord::Migration[5.0]
  def change
 		add_column :orders, :status_id, :integer, :default => 0
  end
end
