class Orders::ValidateInventory
  include Interactor

  def call
    context.items.each do |item|
      show = Show.find_by(id: item[:show_id])

      context.fail!(error: "Show #{item[:show_id]} not found") unless show

      if show.available_inventory < item[:quantity]
        context.fail!(error: "Insufficient inventory for #{show.name}")
      end
    end
  end
end
