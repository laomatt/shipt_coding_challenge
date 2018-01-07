require 'rails_helper'
require 'database_cleaner'
require 'byebug'

RSpec.describe Order, type: :model do
	before(:each) do 
		@customer1 = FactoryGirl.create(:customer, name: 'customer')
		@customer2 = FactoryGirl.create(:customer, name: 'customer2')
		@customer3 = FactoryGirl.create(:customer, name: 'customer3')

		@category_entertainment = FactoryGirl.create(:category, name: 'entertainment')
		@category_book = FactoryGirl.create(:category, name: 'book')
		@category_movie = FactoryGirl.create(:category, name: 'movie')
		@category_stienbeck = FactoryGirl.create(:category, name: 'stienbeck')

		@moana = FactoryGirl.create(:product, name: 'Moana')
		FactoryGirl.create(:product_category, product_id: @moana.id , category_id: @category_movie.id)
		FactoryGirl.create(:product_category, product_id: @moana.id , category_id: @category_entertainment.id)

		@zootopia = FactoryGirl.create(:product, name: 'Zootopia')
		FactoryGirl.create(:product_category, product_id: @zootopia.id , category_id: @category_movie.id)
		FactoryGirl.create(:product_category, product_id: @zootopia.id , category_id: @category_entertainment.id)

		@stienbeck = FactoryGirl.create(:product, name: 'Of Mice and Men')
		FactoryGirl.create(:product_category, product_id: @stienbeck.id , category_id: @category_stienbeck.id)
		FactoryGirl.create(:product_category, product_id: @stienbeck.id , category_id: @category_book.id)
		FactoryGirl.create(:product_category, product_id: @stienbeck.id , category_id: @category_entertainment.id)

		@tolstoy = FactoryGirl.create(:product, name: 'War and Peace')
		FactoryGirl.create(:product_category, product_id: @tolstoy.id , category_id: @category_book.id)
		FactoryGirl.create(:product_category, product_id: @tolstoy.id , category_id: @category_entertainment.id)

		@prods_mult = {
						@moana.id => 3,
						@zootopia.id => 1,
						@stienbeck.id => 1
					}.to_json
				
		@order_valid = Order.create(:customer_id => @customer2.id, :products => @prods_mult)
		@order_valid2 = Order.create(:customer_id => @customer1.id, :products => @prods_mult)
		@order_valid3 = Order.create(:customer_id => @customer1.id, :products => @prods_mult)
	end

	context 'success' do 
		it "makes sure an order can be created" do 
			prods = {
						@moana.id => 3
					}.to_json

			@order = Order.new(:customer_id => @customer1.id, :products => prods)

			expect(@order.save).to eq true
		end

		it "makes sure an order can be created with multiple products" do 
			prods = {
						@moana.id => 3,
						@zootopia.id => 1
					}.to_json
				
			@order_mult = Order.new(:customer_id => @customer2.id, :products => prods)
			expect(@order_mult.save).to eq true
		end
	end

	context 'validations' do

		it "makes sure an order cannot be advanced to an invalid status" do
			@order_valid.status_id = 9
			expect(@order_valid.save).to eq false
			expect(@order_valid.errors.full_messages).to eq ["Status This is not a valid status."]
		end

		it "makes sure an order can only be created with a valid product" do
			# @order_valid.products = 9
			prods = {
						@moana.id => 3,
						33 => 1
					}.to_json

			@order_valid.products = prods
			expect(@order_valid.save).to eq false
			expect(@order_valid.errors.full_messages).to eq ["Product 33 not found."]
		end

		it 'add product to order' do 
			@order_valid.add_product(55,3)
			expect(@order_valid.save).to eq false
			expect(@order_valid.errors.full_messages).to eq ["Product 55 not found."]
		end

		it "makes sure an order can only be created with a valid customer" do
			@order_valid.customer_id = 9
			expect(@order_valid.save).to eq false
			expect(@order_valid.errors.full_messages).to eq ["Customer must exist"]
		end
	end

	context 'instance methods' do 
		it 'displays #product_list' do 
			expect(@order_valid.product_list).to eq JSON.parse(@prods_mult)
		end

		it 'advance order status' do 
			Order.status_list.each do |code, desc|
				@order_valid.status_id = code
				@order_valid.save
				expect(@order_valid.currently).to eq desc
			end
		end

		it 'add product to order' do 
			@order_valid.add_product(@tolstoy.id, 2)
			expect(@order_valid.product_list[@tolstoy.id.to_s]).to eq '2'
		end

		it 'change product quantity' do 
			@order_valid.add_product(@tolstoy.id, 5)
			expect(@order_valid.product_list[@tolstoy.id.to_s]).to eq '5'
		end

		it 'remove product from order' do
			@order_valid.remove_product(@tolstoy.id)
			expect(@order_valid.product_list[@tolstoy.id.to_s]).to eq nil
		end

		it 'displays quantity' do 
			expect(@order_valid.get_quantity(@moana.id)).to eq '3'
			expect(@order_valid.get_quantity(@tolstoy.id.to_s)).to eq ''
		end
	end

	context 'test stats' do 
		it 'displays stats' do 
			expect(Order.statistics).to eq ["1 customer 3 movie 8.0", "1 customer 1 entertainment 10.0", "1 customer 4 stienbeck 2.0", "1 customer 2 book 2.0", "2 customer2 3 movie 4.0", "2 customer2 1 entertainment 5.0", "2 customer2 4 stienbeck 1.0", "2 customer2 2 book 1.0"]
		end
	end

   after(:each) do 
    DatabaseCleaner.clean
  end
end
