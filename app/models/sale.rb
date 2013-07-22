class Sale < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    complete :boolean, :default => false
    completed_at :datetime
    timestamps
  end
  attr_accessible :lines, :complete
  
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
  def total
    lines.sum(:price)
  end
  
  def name
    if refunded_ticket
      "#{I18n.t('sale.refund')} ticket #{refunded_ticket_id}"
    else
      "Ticket #{id}"
    end
  end
  
  # --- Hooks --- #
  include ActiveModel::Dirty  # http://api.rubyonrails.org/classes/ActiveModel/Dirty.html
  before_save :set_completed_time
  def set_completed_time
    if complete && complete_changed?
      self.completed_at = Time.now
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
