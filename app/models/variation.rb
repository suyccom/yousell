class Variation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name  :string
    value :string
    timestamps
  end
  attr_accessible :name, :value

  has_many :product_types, :through => :product_type_variations, :accessible => true
  has_many :product_type_variations, :dependent => :destroy

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
