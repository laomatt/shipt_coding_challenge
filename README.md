# README

This application is an API for getting and placing orders to a database.

## Additional questions

<p>
	<b>Question:</b> We want to give customers the ability to create lists of products for a one-click ordering of bulk items. How would you design the tables, what are the pros and cons of your approach?
	<br>
	<br>
	Answer:  I designed the 'orders' table to have a 'products' column, which holds a json object that is parsable via ruby.  I decided not to go with a join table, because of scalability: it makes no sense to have a join table that will map 1 to 1 with the orders table (even though orders may share products, they will never share items in that join table between orders and products).  That way when an order is created, a customer may place as many products (and quantities) for each of those products by entering one json string (that is compiled on the client, and stored in the session, or cookie), as opposed to creating join table rows for each product desired.  The downside of this approach would be generally slower queries when tabulating statistics of product orders, there are new sql tools made for parsing JSON, but they are difficult to implement and do necessarily not guarantee a quicker turn around.
</p>
<hr>

<p>
	Question: If Shipt knew the exact inventory of stores, and when facing a high traffic and limited supply of a particular item, how do you distribute the inventory among customers checking out?
	<br>
	<br>
	Answer: I would distribute the inventory based on how much of the inventory is left, for example, the nintendo switch, or the newest iphone would be limited to a certain amount per customer to prevent inventory hoarding and reselling.  If the inventory is running out at a certain rate, then that amount (that each customer is limited to) would shrink. 
</p>
<hr>
<p>
	<b>Question:</b> Ability to export the results of #5 to CSV.
	<br>
	<br>
	<b>Answer:</b> What is #5?  CSV manipulation would usually be done in the client.
</p>


## Configuration and setup

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
This endpoint will send back an array of what each customer does with the format: `customer_id customer_first_name category_id category_name number_purchased`.

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
This endpoint will send back an array of what each customer does.

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
This endpoint will delete an entire order.

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
