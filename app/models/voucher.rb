class Voucher < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name            :string, :unique
    amount          :float
    state           enum_string(:emitido, :canjeado)
    sale_id         :integer
    timestamps
  end
  attr_accessible :name, :amount, :state, :payment_id, :sale_id

  belongs_to :payment

  before_create :set_values
  def set_values
    self.state = "emitido"
    self.name = Voucher.all.size == 0 ? "#{Date.today}-000001" : "#{Date.today}-#{"%06d" % (Voucher.last.name.last(6).to_i + 1)}"
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
