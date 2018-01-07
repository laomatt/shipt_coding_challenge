Rails.application.routes.draw do
  # this is the API
  namespace :v1 do 
	  resources :orders do
	  	collection do
	  		get 'show_stats'
	  	end
	  end
	  resources :products
  end
end
