# README

This application is an API for getings and placing orders to a database.

Things you may want to cover:

* Ruby version 2.6

* Database creation
	```
		rake db:create
	```

* Database initialization
	```
		rake db:migrate
		rake db:seed
	```

* How to run the test suite
	```
		rake spec
	```

* Deployment instructions
	```
		bundle install
	```


## API manual

### Showing stats
<p>This endpoint will send back an array oof what each customer does of the format: `customer_id customer_first_name category_id category_name number_purchased`.</p>

```

	GET    /v1/orders/show_stats(.:format)

	request parameters:  {
		:format => :json
	}

	also takes in optional :options parameter
	eg.
	request parameters:  {
		:format => :json,
		:option => { 
			:start => Date.today - 2.days, 
			:end => Date.today + 4.days 
		}
	}

	eg. response: 
		{
			"code"=>200, 
			"status"=>"Stats found.", 
			"body"=>
				[
					"1 customer 3 movie 8.0", 
					"1 customer 1 entertainment 10.0", 
					"1 customer 4 stienbeck 2.0", 
					"1 customer 2 book 2.0", 
					"2 customer2 3 movie 4.0", 
					"2 customer2 1 entertainment 5.0", 
					"2 customer2 4 stienbeck 1.0", 
					"2 customer2 2 book 1.0"
				]
		}

```


### Showing list or current orders
<p>This endpoint will send back an array of all current orders.</p>

```
	GET    /v1/orders(.:format)

	parameters:  {
		:format => :json
	}

	eg. response:
		{
			"code"=>200, 
			"status"=>"Orders listed.", 
			"orders"=>[
				{"id"=>1, "customer_id"=>2, "products"=>"{\"1\":3,\"2\":1,\"3\":1}", "created_at"=>"2018-01-07T03:50:31.386Z", "updated_at"=>"2018-01-07T03:50:31.386Z", "status_id"=>0, "status"=>"new"}, 
				{"id"=>2, "customer_id"=>1, "products"=>"{\"1\":3,\"2\":1,\"3\":1}", "created_at"=>"2018-01-07T03:50:31.390Z", "updated_at"=>"2018-01-07T03:50:31.390Z", "status_id"=>0, "status"=>"waiting for delivery"}, 
				{"id"=>3, "customer_id"=>1, "products"=>"{\"1\":3,\"2\":1,\"3\":1}", "created_at"=>"2018-01-07T03:50:31.393Z", "updated_at"=>"2018-01-07T03:50:31.393Z", "status_id"=>0, "status"=>"delivered"}
			]
		}

```



### Showing one order
<p>This endpoint will send back an array oof what each customer does.</p>

```
	GET    /v1/orders/:id(.:format) 

	parameters:  {
		:format => :json,
		:id => order ID
	}

	eg. response:
		{
			"code"=>200, 
			"status"=>"Order found.", 
			"order"=>
				{
					"id"=>1, 
					"status"=>"new", 
					"products"=>
						{
							"1"=>3, 
							"2"=>1, 
							"3"=>1
						}
				}
		}

```



### Creating an order
<p>This endpoint will create an order.</p>

```
	POST   /v1/orders(.:format) 

	parameters:  {
		:format => [:json],
		:order => {
			:customer_id => 2
			:products => "{\"3\":5,\"4\":60}"
		}
	}

	eg. response:
		{
			"code"=>200, 
			"status"=>"Order created."
		}

```



### Updating an order
<p>This endpoint will update product quantity on an order, or remove a product from an order.</p>

```
	PATCH  /v1/orders/:id(.:format) 

	parameters:  {
		:format => [:json],
		:id => order ID,
		:type => 'update'
		:order => {
			:product_id => product ID,
			:quantity => new quantity
		}
	}

	eg. response:
		{
			"code"=>200, 
			"status"=>"Order updated."
		}

```



### Deleting an order
<p>This endpoint will delete an entire order.</p>

```
	DELETE /v1/orders/:id(.:format)       
	parameters:  {
		:format => :json,
		:id => order ID,
	}

	eg. response:
		{
			"code"=>200, 
			"status"=>"Order Deleted."
		}

```


### Obtaining a product incremental sales report
<p># An API endpoint that accepts a date range and a day, week, or month and returns a breakdown of products sold by quantity per day/week/month.</p>

```
	GET    /v1/orders/show_product_stats(.:format)

		parameters:  { 
        :format => :json, 
        :options => 
          {
            :start => Date.today - 20.days, 
            :end => Date.today + 20.days, 
            :increment => 'week'
          }
        }

		eg. response:
			{
				"code"=>200, 
				"status"=>"Status shown.", 
				"orders"=>
					[
						{"products_sold"=>{}, "start"=>"2017-12-17", "end"=>"2017-12-24"}, 
						{"products_sold"=>{}, "start"=>"2017-12-24", "end"=>"2017-12-31"}, 
						{"products_sold"=>{}, "start"=>"2017-12-31", "end"=>"2018-01-07"}, 
						{"products_sold"=>{"1"=>9, "2"=>3, "3"=>3}, "start"=>"2018-01-07", "end"=>"2018-01-14"}, 
						{"products_sold"=>{}, "start"=>"2018-01-14", "end"=>"2018-01-21"}, 
						{"products_sold"=>{}, "start"=>"2018-01-21", "end"=>"2018-01-28"}
					]
			}

```


### Obtaining a report for a customer
<p>Get orders for a customer</p>
```
		GET    /v1/orders/customer_report(.:format)

			parameters: {
				:format => :json, 
				:customer_id => 1
			}

			eg. response:
				{
					"code"=>200, 
					"status"=>"Orders found.", 
					"orders"=>
						[
							{"id"=>2, "status"=>"new", "products"=>{"1"=>3, "2"=>1, "3"=>1}}, 
							{"id"=>3, "status"=>"new", "products"=>{"1"=>3, "2"=>1, "3"=>1}}
						]
					}
```
<!-- TODO: CRUD for products -->

What is #5?  CSV manipulation would usually be done in the client.
```Ability to export the results of #5 to CSV.```

```
	GET    /v1/products(.:format)         
	parameters:  {
		:format => [:json],
		:order => {}
	}


	POST   /v1/products(.:format)         
	parameters:  {
		:format => [:json],
		:order => {}
	}


	GET    /v1/products/new(.:format)     
	parameters:  {
		:format => [:json],
		:order => {}
	}


	GET    /v1/products/:id/edit(.:format)
	parameters:  {
		:format => [:json],
		:product => {}
	}


	GET    /v1/products/:id(.:format)     
	parameters:  {
		:format => [:json],
		:product => {}
	}


	PATCH  /v1/products/:id(.:format)     
	parameters:  {
		:format => [:json],
		:product => {}
	}

	PUT    /v1/products/:id(.:format)     
	parameters:  {
		:format => [:json],
		:product => {}
	}

	DELETE /v1/products/:id(.:format)     
	parameters:  {
		:format => [:json],
		:product => {}
	}

```
