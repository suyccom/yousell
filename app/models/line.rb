class Line < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name  :string
    price :decimal, :precision => 8, :scale => 2, :default => 0
    discount :string
    amount :integer, :default => 1
    timestamps
  end
  attr_accessible :name, :price, :discount, :product, :sale, :product_id, :sale_id, :amount
  
  belongs_to :sale
  belongs_to :product

  validates_presence_of :sale, :product

  # --- Hooks --- #
  before_create :copy_product_name
  def copy_product_name
    self.name = product.name
  end
  
  before_save :update_price
  def update_price
    self.price = product.price * amount
	self.price = self.price * -1 if self.sale.refunded_ticket
    if self.discount && !self.discount.empty?
      if self.discount.include?("%")
        self.price = self.price - ((self.price * self.discount.to_i)/100)
      else
        self.price = self.price - self.discount.to_i
      end
    end
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
