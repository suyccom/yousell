class ProductVariation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    value :string
    timestamps
  end
  attr_accessible :value

  belongs_to :variation
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
