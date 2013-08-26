class ProductType < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name          :string
    timestamps
  end
  attr_accessible :name, :products

  has_many :products, :accessible => true

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    products.size == 0 && acting_user.administrator?
  end

  def destroy_permitted?
    products.size == 0 && acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
