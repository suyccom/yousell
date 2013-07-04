class Line < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name  :string
    price :decimal, :precision => 8, :scale => 2, :default => 0
    amount :integer, :default => 1
    timestamps
  end
  attr_accessible :name, :price, :product, :sell, :product_id, :sell_id
  
  belongs_to :sell
  belongs_to :product

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
