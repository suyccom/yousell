class ProductType < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name          :string
    default_price :decimal, :precision => 8, :scale => 2, :default => 0
    timestamps
  end
  attr_accessible :name, :default_price, :variations

  has_many :variations, :through => :product_type_variations, :accessible => true
  has_many :product_type_variations, :dependent => :destroy

  has_many :products

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
