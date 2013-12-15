class Voucher < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name            :string
    amount          :float
    state           enum_string(:emitido, :canjeado)
    timestamps
  end
  attr_accessible :name, :amount, :state, :payment_id

  belongs_to :payment

  before_create :set_state
  def set_state
    self.state = "emitido"
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
