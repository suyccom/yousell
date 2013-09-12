class Payment < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    amount :decimal, :precision => 8, :scale => 2, :default => 0
    timestamps
  end
  attr_accessible :amount, :sale_id, :payment_method_id

  # --- Relations --- #
  belongs_to :sale
  belongs_to :payment_method

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
