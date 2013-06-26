class ProductType < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name          :string
    default_price :decimal, :precision => 8, :scale => 2, :default => 0
    timestamps
  end
  attr_accessible :name, :default_price

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
