# encoding: utf-8
class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name    :string
    price   :decimal, :precision => 8, :scale => 2, :default => 0
    barcode :string, :unique
    description :string
    timestamps
  end
  attr_accessible :price, :amount, :barcode, :product_type, :product_type_id, :product_variations, 
    :provider_code, :provider, :provider_id, :warehouse, :warehouse_id, :code,
    :product_warehouses, :description

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
  validates :description, :length => { :maximum => 8 }

  # --- Scopes --- #
  scope :variaciones, lambda { |values|
    if !values.blank?
      clauses = []
      args = []
      for value in values.split(",")
        clauses << "products.name LIKE ?"
        args << "%#{value}%"
      end
    clause = clauses.join(' AND '), *args
    end
    where(clause).
    group("products.id")
  }

  # --- Callbacks --- #
  before_save :set_name
  def set_name
    for p in self.product_variations
      if p.value != I18n.t('product.wihout_variation')
        variations = "#{variations} #{p.value}"
      end
    end
    self.name = "#{provider} #{product_type.name} #{variations}"
  end


  before_update :set_barcode_if_necessary
  def set_barcode_if_necessary
    old_barcode = barcode
    new_barcode = calculate_barcode
    product = Product.find_by_barcode(new_barcode)
    if product.blank?
      self.barcode = new_barcode
    else
      if old_barcode != new_barcode
        errors.add :barcode, "El producto ya existe y no puedes actualizarlo"
      end
    end
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
      ProductWarehouse.create(:warehouse => warehouse, :product_id => self.id, :amount => 0)
    end
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
        # What format have this? If it can be F000, 1000, 100, 300Z, 6000X, etc... Why dont have this field as wildcard and all that user puts here save it in our database 
        zero_amount = piece[:chars] - product_type.name.size
        string += "0" * zero_amount + product_type.name unless product_type.name.blank?
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
