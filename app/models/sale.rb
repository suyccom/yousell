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
        self.type_discount == "%" ? (lines.sum(:price) * self.total_discount)/100 : self.total_discount
    else
      0
    end
  end

  def total
    voucher_amount = Voucher.find_by_sale_id(self.id) ? Voucher.find_by_sale_id(self.id).amount : 0
    lines.sum(:price) - discount + voucher_amount
  end
  
  def created_date
    created_at.to_date
  end
  
  def complete_address
    "#{address} #{zip_code} #{city}"
  end

  def name
    refunded_ticket ? "#{I18n.t('sale.refund')} ticket #{refunded_ticket_id}" : "Ticket #{id}"
  end

  def pending_amount
    return self.total - self.payments.sum(:amount)
  end

  # --- Hooks --- #
  after_create :save_and_print_ticket
  def save_and_print_ticket
    FileUtils.mkdir( File.join(TICKETS_PATH, self.created_at.year.to_s) ) unless File.exist?( File.join(TICKETS_PATH, Date.today.year.to_s) )
    ticket_item_abs_path = File.join(TICKETS_PATH, self.created_at.year.to_s, self.id.to_s + '.txt')
    File.open(
      ticket_item_abs_path,
      'w'
    ) do |f| f.write(ticket_content(self.lines)) end
    system("lp -o cpi=18 -o lpi=10 #{ticket_item_abs_path}") unless Rails.env.development?
  end
  def ticket_content(lines)
    'Esto es una prueba'
  end

  include ActiveModel::Dirty  # http://api.rubyonrails.org/classes/ActiveModel/Dirty.html
  before_save :attributes_ticket_stock
  def attributes_ticket_stock
    # Only run if the sale has just been marked as completed
    if complete && complete_changed? && !completed_at
      self.payments.delete_all if day_sale # Only run if the sale is day sale.
      self.completed_at = Time.now
      self.sale_total = self.total
      # En el controlador tengo que contabilizar si un producto tiene stock y cuanto para el aviso.
      for line in lines
        if line.amount > 0
        # If we are here it is because warehouses have stock. We remove the product in the stock that has amount.
          pw = line.product.current_product_warehouse.amount <= 0 ? line.product.product_warehouses.where("amount > 0").first : line.product.current_product_warehouse
        elsif line.amount < 0
          pw = line.product.current_product_warehouse
        end
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
