class Order < ApplicationRecord
	# belongs_to :product
	belongs_to :customer
	validate :valid_product, :valid_status

 # TODO: put this in database, make a model
	@@valid_statuses = {
	 	0 => "new",
	 	1 => "waiting for delivery", 
	 	2 => "on its way", 
	 	3 => "delivered"
	 }

	def self.status_list
		@@valid_statuses
	end

	def self.statistics(options={})
		results = []
		Customer.all.each do |customer|
			customer_id = customer.id
			customer_name = customer.name
			categ = {}
			customer.orders.each do |order|
				next if ( options != {} && (order.created_at.to_date <= options['start'].to_date || order.created_at.to_date >= options['end'].to_date))
				prods = JSON.parse(order.products)
				prods.each do |product_id,quantity|
					categories = Product.find(product_id).product_categories.map { |e| e.category }
					categories.each do |category|
						if categ[category].nil?
							categ[category] = 0
						end

						categ[category] += quantity.to_f
					end
				end
			end

			categ.each do |k,v|
				results << "#{customer_id} #{customer_name} #{k.id} #{k.name} #{v} #{(v.to_f > 1 ? k.unit.try(:pluralize) : k.unit)}".try(:rstrip)
			end
		end

		results
	end

	def valid_status
		if !@@valid_statuses.keys.include?(status_id)
			errors.add(:status_id, "This is not a valid status.")
		end
	end

	def valid_product
		prod_list = JSON.parse(products)
		prod_list.each do |product_id,quantity|
			if !Product.exists?(:id => product_id.to_i)
				errors.add(:product, "#{product_id} not found.")
			end
		end
	end

	def currently
		@@valid_statuses[status_id]
	end

	def add_product(product_id, quantity)
		# TODO: make sure an order cannot be changed if it is on its way or beyond
		prod_list_temp = product_list
		prod_list_temp[product_id.to_s] = quantity.to_s
		self.products = prod_list_temp.to_json
		self.save
	end

	def remove_product(product_id)
		# TODO: make sure an order cannot be changed if it is on its way or beyond
		prod_list_temp = product_list
		prod_list_temp.delete(product_id.to_s)
		self.products = prod_list_temp.to_json
		self.save		
	end

	def change_product_quantity(product_id, quantity)
		# TODO: make sure an order cannot be changed if it is on its way or beyond
		prod_list_temp = product_list
		prod_list_temp[product_id.to_s] = quantity.to_s
		products = prod_list_temp.to_json
		save
	end

	def get_quantity(product_id)
		product_list[product_id.to_s].to_s
	end

	def product_list
		JSON.parse(products)
	end

end
