class Sale < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    complete :boolean, :default => false
    day_sale :boolean, :default => false
    sale_total :decimal, :precision => 8, :scale => 2, :default => 0
    total_discount :integer, :default => 0
    type_discount :string, :default => '%'
    completed_at :datetime
    client_name :string
    tax_number :string
    address :string
    zip_code :string
    city :string
    timestamps
  end
  attr_accessible :lines, :complete, :day_sale, :total_discount, :type_discount, 
    :sale_total, :client_name, :tax_number, :address, :zip_code, :city

  # --- Relations --- #
  has_many :payments
  has_many :lines
  children :lines
  belongs_to :refunded_ticket, :class_name => 'Sale'
  has_one :refund, :class_name => 'Sale', :foreign_key => 'refunded_ticket_id'

  # --- Validations --- #
  validate :lines_are_required_for_complete_sales
  def lines_are_required_for_complete_sales
    if complete && lines.count == 0
      errors[:base] << "At least one line is required to complete a sale"
    end
  end

  # --- Custom methods --- #
  def discount
    if self.total_discount? && self.total_discount > 0
      if self.type_discount == "%"
        (lines.sum(:price) * self.total_discount)/100
      else
        self.total_discount
      end
    else
      0
    end
  end

  def total
    lines.sum(:price) - discount
  end
  
  def created_date
    created_at.to_date
  end
  
  def complete_address
    "#{address} #{zip_code} #{city}"
  end

  def name
    if refunded_ticket
      "#{I18n.t('sale.refund')} ticket #{refunded_ticket_id}"
    else
      "Ticket #{id}"
    end
  end

  def pending_amount
    return self.total - self.payments.sum(:amount)
  end

  # --- Hooks --- #
  include ActiveModel::Dirty  # http://api.rubyonrails.org/classes/ActiveModel/Dirty.html
  before_save :set_some_attributes
  def set_some_attributes
    # Only run if the sale has just been marked as completed
    if complete && complete_changed? && !completed_at
      self.completed_at = Time.now
      self.sale_total = self.total
      for line in lines
        pw = line.product.current_product_warehouse
        pw.update_attribute(:amount, pw.amount - line.amount)
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
