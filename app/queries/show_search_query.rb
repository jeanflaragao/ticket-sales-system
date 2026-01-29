class ShowSearchQuery
  def initialize(relation = Show.all)
    @relation = relation
  end

  def call(params = {})
    @relation = filter_by_availability(params[:available])
    @relation = filter_by_price_range(params[:min_price], params[:max_price])
    @relation = search_by_name(params[:search])
    @relation = filter_by_date_range(params[:start_date], params[:end_date])
    @relation = sort_results(params[:sort])

    @relation
  end

  private

  def filter_by_availability(available)
    return @relation if available.nil?

    if available == 'true'
      @relation.where('total_inventory - reserved_inventory - sold_inventory > 0')
    elsif available == 'false'
      @relation.where('total_inventory - reserved_inventory - sold_inventory <= 0')
    else
      @relation
    end
  end

  def filter_by_price_range(min_price, max_price)
    return @relation unless min_price.present? && max_price.present?

    @relation.where(price: min_price.to_f..max_price.to_f)
  end

  def search_by_name(search_term)
    return @relation if search_term.blank?

    @relation.where('name ILIKE ?', "%#{search_term}%")
  end

  def filter_by_date_range(start_date, end_date)
    return @relation unless start_date.present? && end_date.present?

    @relation.where(created_at: start_date..end_date)
  end

  def sort_results(sort_param)
    case sort_param
    when 'name'
      @relation.order(name: :asc)
    when 'price_low'
      @relation.order(price: :asc)
    when 'price_high'
      @relation.order(price: :desc)
    when 'newest'
      @relation.order(created_at: :desc)
    else
      @relation.order(created_at: :desc)
    end
  end
end
