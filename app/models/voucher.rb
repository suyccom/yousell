class Voucher < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    validity_period :date
    amount          :float
    timestamps
  end
  attr_accessible :validity_period, :amount

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
