class Line < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name  :string
    price :decimal, :precision => 8, :scale => 2, :default => 0
    amount :integer, :default => 1
    timestamps
  end
  attr_accessible :name, :price, :product, :sale, :product_id, :sale_id, :amount
  
  belongs_to :sale
  belongs_to :product

  validates_presence_of :sale, :product
  validate :only_one_line_per_sale
  def only_one_line_per_sale
  end

  # --- Hooks --- #
  before_create :copy_product_name
  def copy_product_name
    self.name = product.name
  end
  
  before_save :update_price
  def update_price
    self.price = product.price * amount
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
