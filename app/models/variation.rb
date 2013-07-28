class Variation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name  :string
    value :string
    timestamps
  end
  attr_accessible :name, :value

  # --- Relations --- #
  has_many :product_type_variations, :dependent => :destroy
  has_many :product_types, :through => :product_type_variations, :accessible => true

  has_many :product_variations, :dependent => :destroy
  has_many :products, :through => :product_variations, :accessible => true

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
