class ShowsController < ApplicationController
  
  before_action :log_request

  before_action :set_show, only: [:show, :update, :availability]

  after_action :log_response, only: [:create]

  around_action :benchmark

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    @shows = Show.page(page).per(per_page)
    
    @shows = @shows.where('total_inventory - reserved_inventory - sold_inventory >= ?', params[:min_available]) if params[:min_available]

    @shows = @shows.where('name ILIKE ?', "%#{params[:search]}%") if params[:search]
  
    # Filter by availability
    if params[:available] == 'true'
      @shows = @shows.available
    elsif params[:available] == 'false'
      @shows = @shows.sold_out
    end
    
    render json: {
      shows: @shows,
      meta: {
        current_page: @shows.current_page,
        total_pages: @shows.total_pages,
        total_count: @shows.total_count,
        per_page: per_page.to_i
      }
    }
  end

  def show
    @show = Show.find(params[:id])
    render json: @show
  end

  def create
    @show = Show.new(show_params)
    
    if @show.save
      render json: @show, status: :created
    else
      render json: { 
        errors: @show.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  def update
    if @show.update(show_params)
      render json: @show
    else
      render json: { 
        errors: @show.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  def availability
    render json: {
      show_id: @show.id,
      show_name: @show.name,
      available: @show.available_inventory,
      total: @show.total_inventory,
      sold: @show.sold_inventory,
      percentage_sold: (@show.sold_inventory.to_f / @show.total_inventory * 100).round(2)
    }
  end

  private
  
  def set_show
    @show = Show.find(params[:id])
  end
  
  def show_params
    params.require(:show).permit(
      :name, 
      :total_inventory, 
      :reserved_inventory, 
      :sold_inventory
    )
  end

  def log_request
    Rails.logger.info "Request: #{request.method} #{request.path}"
  end
  
  def log_response
    Rails.logger.info "Response: #{response.status}"
  end
  
  def benchmark
    start = Time.now
    yield  # Execute the action
    duration = Time.now - start
    Rails.logger.info "Action took #{duration} seconds"
  end

end
