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

  # GET v1/order/show_product_stats
  def show_product_stats
    increment = show_product_stats_params[:increment]
    start_date_total = show_product_stats_params[:start]
    end_date_total = show_product_stats_params[:end]

    dates = []
    # break down start_date_total to end_date_total by the choosen increment
    current_date = start_date_total.to_date
    while current_date < end_date_total.to_date
      this_inc = {:products_sold => {}}
      this_inc[:start] = current_date
      if increment == 'day'
        current_date = current_date + 1.day
      elsif increment == 'week'
        current_date = current_date + 1.week
      elsif increment == 'month'
        current_date = current_date + 1.month
      end
      this_inc[:end] = current_date

      dates << this_inc
    end


    orders = Order.where("created_at BETWEEN ? and ?", start_date_total, end_date_total)
    orders.each do |ord|
      products_sold = {}
      prods = JSON.parse(ord.products)
      prods.each do |product_id,quantity|
        # go through each product
        # find the key in the date hash where the order belongs to
        this_date = dates.detect { |e| e[:start].to_date >= ord.created_at.to_date }
        if this_date[:products_sold][product_id].nil?
          this_date[:products_sold][product_id] = 0
        end

        this_date[:products_sold][product_id] += quantity
      end
    end

    respond_to do |format|
      format.json { render :json => {
        :code => 200, 
        :status => 'Status shown.',
        :orders => dates
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
        	:order => { :id => @order.id, :customer_id => @order.customer_id, :status => @order.currently, :products => @order.product_list }
        	} 
        }
      end
    end
  end

  def customer_report
    @customer = Customer.find(params[:customer_id])
    orders = []
    @customer.orders.each do |order|
      orders << { :id => order.id, :customer_id => order.customer_id, :status => order.currently, :products => order.product_list }
    end
    respond_to do |format|
        format.json { render :json => {
          :code => 200, 
          :status => 'Orders found.',
          :orders => orders
          } 
        }
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

    def show_product_stats_params
      params.require(:options).permit(:start, :end, :increment)
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
