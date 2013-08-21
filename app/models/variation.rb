# encoding: utf-8
class Variation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name  :string
    timestamps
  end
  attr_accessible :name, :variation_values

  # --- Relations --- #
  has_many :product_variations, :dependent => :destroy
  has_many :products, :through => :product_variations, :accessible => true
  
  has_many :variation_values, :accessible => true
  
  def value
    variation_values.*.name.join(',')
  end

  after_create :add_null_value
  def add_null_value
   self.variation_values.create(:name => I18n.t('product.without_variation'), :code => "XX")
  end


  # --- Permissions --- #
  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator? && products.count == 0
  end

  def view_permitted?(field)
    true
  end

end
