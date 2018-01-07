# README

This application is an API for getings and placing orders to a database.

Things you may want to cover:

* Ruby version 2.6

* Database creation
	`
		rake db:create
	`
* Database initialization
	`
		rake db:migrate
		rake db:seed
	`

* How to run the test suite
	`
		rake spec
	`

* Deployment instructions
	`
		bundle install
	`


API manual
```
GET    /v1/orders/show_stats(.:format)
	parameters:  {
		:format => [:json],
	}

GET    /v1/orders(.:format)           
	parameters:  {
		:format => [:json],
		:order => {}
	}
POST   /v1/orders(.:format)           
	parameters:  {
		:format => [:json],
		:order => {}
	}

GET    /v1/orders/:id/edit(.:format)  
	parameters:  {
		:format => [:json],
		:order => {
			:customer_id => [integer]
			:products => [json text]
		}
	}

GET    /v1/orders/:id(.:format)       
	parameters:  {
		:format => [:json],
		:id => order ID,
	}

PATCH  /v1/orders/:id(.:format)       
	parameters:  {
		:format => [:json],
		:id => order ID,
		:order => {
			:product_id => [product ID],
			:quantity => [new quantity]
		}
	}

PUT    /v1/orders/:id(.:format)       
	parameters:  {
		:format => [:json],
		:id => order ID,
		:order => {
			:product_id => [product ID],
			:quantity => [new quantity]
		}
	}

DELETE /v1/orders/:id(.:format)       
	parameters:  {
		:format => [:json],
		:id => order ID,
	}

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
