class ProductWarehouse < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    amount :integer
    timestamps
  end
  
  belongs_to :warehouse
  belongs_to :product
  
  attr_accessible :amount, :warehouse, :product, :warehouse_id, :product_id
  
  def name
    "#{warehouse} #{amount}"
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
