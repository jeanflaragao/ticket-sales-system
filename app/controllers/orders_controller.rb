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
    form = BulkOrderForm.new(
      customer_email: params[:customer_email],
      customer_name: params[:customer_name],
      payment_method: params[:payment_method],
      coupon_code: params[:coupon_code]
    )

    params[:items]&.each do |item|
      form.add_item(item[:show_id], item[:quantity])
    end

    if form.save
      render json: form.order, status: :created
    else
      render json: { errors: form.errors.full_messages }, status: :unprocessable_content
    end
  end

  private

  def order_params
    params.permit(:customer_email, items: %i[show_id quantity])
  end
end
