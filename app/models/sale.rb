class Sale < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    complete :boolean, :default => false
    day_sale :boolean, :default => false
    sale_total :decimal, :precision => 8, :scale => 2, :default => 0
    completed_at :datetime
    timestamps
  end
  attr_accessible :lines, :complete, :day_sale

  has_many :lines
  children :lines

  # --- Validations --- #
  validate :lines_are_required_for_complete_sales
  def lines_are_required_for_complete_sales
    if complete && lines.count == 0
      errors[:base] << "At least one line is required to complete a sale"
    end
  end

  # --- Custom methods --- #
  def total
    lines.sum(:price)
  end

  # --- Hooks --- #
  include ActiveModel::Dirty  # http://api.rubyonrails.org/classes/ActiveModel/Dirty.html
  before_save :set_some_attributes
  def set_some_attributes
    if complete && complete_changed?
      self.completed_at = Time.now
      self.sale_total = self.total
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
