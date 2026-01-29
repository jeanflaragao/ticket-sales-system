class Orders::CreateOrderWorkflow
  include Interactor::Organizer

  # Runs in order, stops on first failure
  # Automatically rolls back on failure
  organize Orders::ValidateInventory,
           Orders::ReserveInventory,
           Orders::CreateOrderRecord,
           Orders::CreateItems,
           Orders::FinalizeInventory
end
