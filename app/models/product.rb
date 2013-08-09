class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name    :string
    price   :decimal, :precision => 8, :scale => 2, :default => 0
    barcode :string, :unique
    timestamps
  end
  attr_accessible :price, :amount, :barcode, :product_type, :product_type_id, :product_variations, 
    :provider_code, :provider, :provider_id, :warehouse, :warehouse_id, :code,
    :product_warehouses
  
  # --- Relations --- #
  belongs_to :product_type
  belongs_to :provider
  has_many :product_variations, :accessible => true, :dependent => :destroy
  has_many :variations, :through => :product_variations
  has_many :product_warehouses, :accessible => true, :dependent => :destroy
  has_many :warehouses, :through => :product_warehouses
  children :product_warehouses

  # --- Validations --- #
  validates_presence_of :provider

  # --- Callbacks --- #
  before_save :set_name
  def set_name
    self.name = "#{provider} #{product_type.name} #{product_variations.*.value.join(' ')}"
  end
  
  after_create :set_barcode, :create_product_warehouses
  def set_barcode
    barcode = calculate_barcode
    product = Product.find_by_barcode(barcode)
    # If there is another product with the same barcode, just add the amount to it and destroy this record
    if product
      product_warehouse = self.product_warehouses.first
      pw = product.product_warehouses.where("warehouse_id = ?", product_warehouse.warehouse_id).first
      # If the product already has this warehouse, sum it
      if pw
        pw.update_attribute(:amount, pw.amount + product_warehouse.amount)
      # Else, assign the new product_warehouse to the product
      else
        product.product_warehouses << ProductWarehouse.new(:warehouse => product_warehouse.warehouse, :amount => product_warehouse.amount)
        product.save
      end
      User.current_user.last_added_products << [product.id, product_warehouse.amount]
      self.destroy
    else
      User.current_user.last_added_products << [self.id, self.amount]
      self.update_attribute(:barcode, calculate_barcode)
    end
    User.current_user.save
  end
  
  def create_product_warehouses
    # Make sure there is a product warehouse record for every existing warehouse
    for warehouse in (Warehouse.all - self.warehouses)
      self.product_warehouses << ProductWarehouse.new(:warehouse => warehouse, :amount => 0)
    end
    self.save
  end
  
  def amount
    product_warehouses.sum(:amount)
  end
  
  def available_amount
    current_product_warehouse ? current_product_warehouse.amount : 1
  end
  
  def current_product_warehouse
    product_warehouses.warehouse_is(User.current_user.current_warehouse).first
  end
  
  def calculate_barcode
    string = ''
    for piece in BARCODE_FORMAT
      case piece[:type]
      when :provider
        string += provider.code
      when :variation
        product_variation = eval("self.#{piece[:name]}")
        string += product_variation ? product_variation.code : ('X' * piece[:chars])
      when :code
        string += "%0#{piece[:chars]}d" % product_type.name unless product_type.name.blank?
      end
    end
    return string
  end
  
  # This hack allows us to call "Product.last.Size". This is useful to write custom barcode formats :)
  def method_missing(meth, *args)
    v = Variation.find_by_name meth.to_s
    if v
      product_variations.variation_is(v).first
    else
      super
    end
  end

  
  
  
  
  # We save temporatily the product code from the add products form
  def code=(v)
    @code = v
  end
  def code
    @code
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
