require 'rails_helper'
require 'database_cleaner'
require 'byebug'

RSpec.describe V1::OrdersController, type: :controller do
  # let(:teacher) {FactoryGirl.create(:teacher)}
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


  describe "GET #index" do
    it "displays list of current orders" do
      get :index, {:format => :json}
      expect(response.code).to eq "200"
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 200
      expect(resp["status"]).to eq "Orders Listed."
      resp["orders"].each { |e| 
      	e.delete('created_at') 
      	e.delete('updated_at') 
      }
      expect(resp["orders"]).to eq Order.all.to_a.map { |e| e.attributes }.each { |e| 
      		e.delete('created_at') 
      		e.delete('updated_at') 
      	}
    end
  end

  describe "POST #create" do
  	it "creates a new order" do
			this_prods_mult = {
				@moana.id => 3,
				@zootopia.id => 1,
				@stienbeck.id => 1
			}.to_json
      post :create, {:format => :json, :order => {:customer_id => @customer1.id, :products => this_prods_mult}}

			expect(response.code).to eq "200"
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 200
      expect(resp["status"]).to eq "Order Created."
  	end

    it "does not create a new order with invalid params" do
    	this_prods_mult = {
				@moana.id => 3,
				@zootopia.id => 1,
				88 => 1
			}.to_json
      post :create, {:format => :json, :order => {:customer_id => @customer1.id, :products => this_prods_mult}}

			expect(response.code).to eq "200"
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 409
      expect(resp["status"]).to eq "You have submitted invalid parameters."
      expect(resp["description"]["product"]).to eq ["88 not found."]
  	end

  end

  describe "GET #show" do
   	it "will show a current order" do
      get :show, {:format => :json, :id => @order_valid.id }
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 200
      expect(resp["status"]).to eq "Order found."
      expect(resp["order"]["id"]).to eq @order_valid.id
      expect(resp["order"]["status"]).to eq @order_valid.currently
      expect(resp["order"]["products"]).to eq @order_valid.product_list
  	end

  	it "sends back error message if no orders found" do
      get :show, {:format => :json, :id => 55 }
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 404
      expect(resp["status"]).to eq "Order not found."
  	end
  end 

  describe "POST #update" do
  	it "updates an existing order" do
  		post :update, {
  			:format => :json, 
  			:id => @order_valid.id, 
  			:product => { 
  				:product_id => @moana.id, 
  				:quantity => 50 
  			}
  		}
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 200
      expect(resp["status"]).to eq "Order Updated."
  	end

  	it "sends back error message if no orders found" do
  		post :update, {:format => :json, :id => 55, :product => { :product_id => @zootopia.id, :quantity => 500 }}
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 404
      expect(resp["status"]).to eq "Order not found."
  	end

  	it "sends back error message if product ids are bad" do
  		post :update, {:format => :json, :id => @order_valid.id, :product => { :product_id => 55, :quantity => 500 }}
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 409
      expect(resp["status"]).to eq "You have submitted invalid parameters."
      expect(resp["description"]["product"]).to eq ["55 not found."]
  	end
  end


  describe "POST #destroy" do
  	it "deletes a current order" do
  		delete :destroy, {:format => :json, :id => @order_valid.id }
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 200
      expect(resp["status"]).to eq "Order deleted."
  	end

  	it "sends back error message if no orders found" do
  		delete :destroy, {:format => :json, :id => 55 }
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 404
      expect(resp["status"]).to eq "Order not found."
  	end
  end

  describe "GET #show_stats" do
  	it 'send back stats' do
	  	get :show_stats, {:format => :json }
      resp = JSON.parse(response.body)
      expect(resp["code"]).to eq 200
      expect(resp["status"]).to eq "Stats found."
      expect(resp["body"]).to eq ["1 customer 3 movie 8.0", "1 customer 1 entertainment 10.0", "1 customer 4 stienbeck 2.0", "1 customer 2 book 2.0", "2 customer2 3 movie 4.0", "2 customer2 1 entertainment 5.0", "2 customer2 4 stienbeck 1.0", "2 customer2 2 book 1.0"]
    end
  end

  after(:each) do 
    DatabaseCleaner.clean
  end
end
