
require 'faker'
beverage = Category.create(:name => 'beverage', :unit => 'liter')
alcohol = Category.create(:name => 'alcohol', :unit => 'liter')
coffee = Category.create(:name => 'coffee', :unit => 'liter')
20.times do 
	beer = Product.create(:name => Faker::Beer.name)
	ProductCategory.create(:category_id => beverage.id, :product_id => beer.id)
	ProductCategory.create(:category_id => alcohol.id, :product_id => beer.id)
	coffee_product = Product.create(:name => Faker::Coffee.blend_name)
	ProductCategory.create(:category_id => beverage.id, :product_id => coffee_product.id)
	ProductCategory.create(:category_id => coffee.id, :product_id => coffee_product.id)
end

food = Category.create(:name => 'food', :unit => 'pound')

30.times do 
	dish = Product.create(:name => Faker::Food.dish)
	ProductCategory.create(:category_id => food.id, :product_id => dish.id)
end

book = Category.create(:name => 'book')
100.times do 
	title = Product.create(:name => Faker::Book.title)
	ProductCategory.create(:category_id => book.id, :product_id => title.id)
end

400.times do 
	customer = Customer.new(:name => Faker::Internet.user_name)
	if !customer.save
		p customer.errors.full_messages
	end
end

50.times do 
	bev = Category.find_by_name('beverage').products.sample
	product = { bev.id => rand(1..100.0)}.to_json
	order = Order.new(:customer_id => Customer.all.sample.id, :products => product)
	if !order.save
		p order.errors.full_messages
	end
end

50.times do 
	food = Category.find_by_name('food').products.sample
	product = {food.id => rand(1..200.0)}.to_json
	order = Order.new(:customer_id => Customer.all.sample.id, :products => product)
	if !order.save
		p order.errors.full_messages
	end
end

50.times do 
	book = Category.find_by_name('book').products.sample
	product = {book.id => (1..90).to_a.sample}.to_json
	order = Order.new(:customer_id => Customer.all.sample.id, :products => product)
	if !order.save
		p order.errors.full_messages
	end
end