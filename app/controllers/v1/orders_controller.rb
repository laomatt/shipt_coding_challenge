class V1::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  # GET v1/orders
	def index
    @orders = Order.all

    results = []
    @orders.each do |ord|
      ord_hash = ord.attributes
      ord_hash[:status] = ord.currently
      results << ord_hash
    end

     respond_to do |format|
      format.json { render :json => {
      	:code => 200, 
      	:status => 'Orders listed.',
      	:orders => results
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
    if params[:options]
    	stats = Order.statistics(stat_options)
    else
      stats = Order.statistics({})
    end
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
        	:status => 'Order created.'
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
    if params[:type] == 'delete'
      @order.remove_product(product_params[:product_id])
    else
      @order.add_product(product_params[:product_id],product_params[:quantity].to_f)
    end

    respond_to do |format|
      if @order.save
        format.json { render :json => { 
        	:code => 200,
        	:status => 'Order updated.'
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

    def stat_options
      params.require(:options).permit(:start, :end)
    end

    def product_params
      params.require(:product).permit(:product_id, :quantity)

    end
end
