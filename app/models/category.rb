class Category < ApplicationRecord
	has_many :product_categories

	def products
		product_categories.map { |e| e.product }
	end
end
