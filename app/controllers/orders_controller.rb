class OrdersController < ApiController
  def index
    @orders = Order.includes(order_items: :show).order(created_at: :desc)
    render json: @orders
  end

  def show
    @order = Order.includes(order_items: :show).find(params[:id])
    render json: OrderPresenter.new(@order).as_json
  end

  def create
    result = Orders::CreateOrderWorkflow.call(
      customer_email: params[:customer_email],
      items: params[:items] || []
    )

    if result.success?
      render json: result.order, status: :created
    else
      render json: { error: result.error }, status: :unprocessable_content
    end
  end

  private

  def order_params
    params.permit(:customer_email, items: %i[show_id quantity])
  end
end
