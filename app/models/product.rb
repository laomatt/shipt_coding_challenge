class Product < ApplicationRecord
	has_many :product_categories
	has_many :orders

	def categories
		product_categories.map { |e| e.category }
	end
end
