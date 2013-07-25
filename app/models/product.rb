class Product < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name    :string
    price   :decimal, :precision => 8, :scale => 2, :default => 0
    amount  :integer
    barcode :string, :unique
    provider_code :string, :required
    timestamps
  end
  attr_accessible :price, :amount, :barcode, :product_type, :product_type_id, :product_variations, :provider_code, :provider, :provider_id

  # --- Relations --- #
  belongs_to :product_type
  belongs_to :provider

  has_many :product_variations, :accessible => true
  has_many :variations, :through => :product_variations

  # --- Validations --- #
  validates_presence_of :provider
  validates :provider_code, :allow_blank => true, :uniqueness => {
    :link => Proc.new{|f| 
      Rails.application.routes.url_helpers.product_path(Product.find_by_provider_code(f[:value]))},
    :provider_code => Proc.new{|f| f[:value] }
  }

  # --- Callbacks --- #
  before_save :set_name
  def set_name
    self.name = "#{product_type} #{product_variations.*.value.join(' ')}"
  end

  before_save :auto_barcode
  def auto_barcode
    self.barcode = self.provider.code + self.provider_code
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
