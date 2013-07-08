class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name    :string
    price   :decimal, :precision => 8, :scale => 2, :default => 0
    amount  :integer
    barcode :string
    timestamps
  end
  attr_accessible :price, :amount, :barcode, :product_type, :product_type_id, :product_variations

  belongs_to :product_type

  has_many :product_variations, :accessible => true
  has_many :variations, :through => :product_variations
  
  before_save :set_name
  def set_name
    self.name = "#{product_type} #{product_variations.*.value.join(' ')}"
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
