# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  def index
    @orders = Order.includes(order_items: :show).order(created_at: :desc)
    render json: @orders
  end
  
  def show
    @order = Order.includes(order_items: :show).find(params[:id])
    render json: @order, include: { order_items: { include: :show } }
  end
  
  def create
    service = CreateOrderService.new(order_params)
    result = service.call
    
    if result.success?
      render json: result.order, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_content
    end
  end
  
  private
  
  def order_params
    params.permit(:customer_email, items: [:show_id, :quantity])
  end
end