class V1::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  # GET v1/orders
	def index
    @orders = Order.all

     respond_to do |format|
      format.json { render :json => {
      	:code => 200, 
      	:status => 'Orders Listed.',
      	:orders => @orders
      	} 
      }
    end
  end

  # GET v1/orders/1
  def show
    respond_to do |format|
			if @order
        format.json { render :json => {
        	:code => 200, 
        	:status => 'Order found.',
        	:order => { :id => @order.id, :status => @order.currently, :products => @order.product_list }
        	} 
        }
      end
    end
  end

  # GET v1/show_stats
  def show_stats
  	stats = Order.statistics
  	respond_to do |format|
        format.json { render :json => {
        	:code => 200, 
        	:status => 'Stats found.',
        	:body => stats
        	} 
        }
    end
  end

  # POST v1/orders
  def create
    @order = Order.new(order_params)

    respond_to do |format|
			if @order.save
        format.json { render :json => {
        	:code => 200, 
        	:status => 'Order Created.'
        	} 
        }
      else
        format.json { 
        	render :json => {
        		:code => 409,
        		:status => 'You have submitted invalid parameters.',
        		:description => @order.errors
        		} 
        	}
      end
    end
  end

  # PATCH/PUT v1/orders/1
  def update
  	prods = @order.product_list
  	prods[product_params[:product_id]] = product_params[:quantity].to_i
  	@order.products = prods.to_json
    respond_to do |format|
      if @order.save
        format.json { render :json => { 
        	:code => 200,
        	:status => 'Order Updated.'
        	} 
        }
      else
        format.json { 
        	render :json => {
        		:code => 409,
        		:status => 'You have submitted invalid parameters.',
        		:description => @order.errors
        		} 
        	}
      end
    end
  end

  # DELETE v1/orders/1
  def destroy
    respond_to do |format|
    	if @order.destroy
         format.json { render :json => { 
        	:code => 200,
        	:status => 'Order deleted.'
        	} 
        }   		
    	end
    end
  end

  private
  	def record_not_found
  		respond_to do |format|
		   format.json { 
	    	render :json => {
	    		:code => 404,
	    		:status => "Order not found."
	    		} 
	    	}
	    end
  	end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:products, :customer_id)
    end

    def product_params
      params.require(:product).permit(:product_id, :quantity)

    end
end
