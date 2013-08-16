class Line < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name  :string
    price :decimal, :precision => 8, :scale => 2, :default => 0
    discount :integer, :default => 0
    type_discount :string, :default => '%'
    amount :integer, :default => 1
    timestamps
  end
  attr_accessible :name, :price, :discount, :type_discount, :product, :sale, :product_id, :sale_id, :amount
  
  belongs_to :sale
  belongs_to :product

  validates_presence_of :sale, :product
  
  validate :check_stock
  def check_stock
    if product && product.available_amount < amount
      errors.add(:amount, I18n.t('activerecord.errors.models.product.attributes.amount.stock'))
    end
  end

  # --- Hooks --- #
  before_create :copy_product_name
  def copy_product_name
    self.name = product.name
  end

  before_save :update_price
  def update_price
    self.price = product.price * amount if product.price
    self.price = self.price * -1 if self.sale.refunded_ticket
    if self.discount && self.discount > 0
      if self.type_discount == "%"
        self.price = self.price - ((self.price * self.discount)/100)
      else
        self.price = self.price - self.discount
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
