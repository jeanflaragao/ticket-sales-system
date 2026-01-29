class ShowsController < ApiController
  def index
    shows = ShowSearchQuery.new.call(search_params)
    render json: shows
  end

  def show
    show = Show.find(params[:id])
    render json: show
  end

  def create
    show = Show.new(show_params)

    if show.save
      render json: show, status: :created
    else
      render json: show.errors, status: :unprocessable_content
    end
  end

  private

  def search_params
    params.permit(:available, :min_price, :max_price, :search, :start_date, :end_date, :sort)
  end

  def show_params
    params
      .require(:show)
      .permit(:name, :total_inventory, :price)
  end
end
