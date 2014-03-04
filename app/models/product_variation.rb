class ProductVariation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    value :string
    code :string
    timestamps
  end
  attr_accessible :value, :variation, :variation_id, :product, :product_id

  belongs_to :variation
  belongs_to :product
  
  before_save :save_code, :touch_product
  def save_code
    self.code = value
  end

  def touch_product
    product.touch
  end
  
  def to_s
    code
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
