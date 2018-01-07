class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
    	t.integer :customer_id 
    	t.text :products #this will be a json object that looks like [{ :product_id => 4, :quantity => 4.5, :unit => lbs }] or [{ :product_id => 5, :quantity => 4 }], this makes more sense, because, orders will never have to share product_orders, so there is no need for a join table

      t.timestamps
    end
  end
end
