require 'rails_helper'

RSpec.describe V1::ProductsController, type: :controller do
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

	# describe "GET index" do
	# 	it "send a list of current availiable products" do
	# 		get :index, {:format => :json }
	# 		resp = JSON.parse(response.body)
 #      expect(resp["code"]).to eq 200
 #      expect(resp["status"]).to eq "Orders Listed."
 #      resp["products"].each { |e| 
 #      	e.delete('created_at') 
 #      	e.delete('updated_at') 
 #      }
 #      expect(resp["products"]).to eq Order.all.to_a.map { |e| e.attributes }.each { |e| 
 #      		e.delete('created_at') 
 #      		e.delete('updated_at') 
 #      	}
	# 	end
	# end

  after(:each) do 
    DatabaseCleaner.clean
  end
end
