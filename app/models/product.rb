class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    price   :decimal, :precision => 8, :scale => 2, :default => 0
    amount  :integer
    barcode :string
    timestamps
  end
  attr_accessible :price, :amount, :barcode

  belongs_to :product_type

  has_many :product_variations
  has_many :variations, :through => :product_variations, :accessible => true

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
