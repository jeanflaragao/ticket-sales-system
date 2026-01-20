class ShowsController < ApiController
  def index
    shows = Show.all
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
      render json: show.errors, status: :unprocessable_entity
    end
  end

  private

  def show_params
     params
      .require(:show)
      .permit(:name, :total_inventory, :price)
  end
end
