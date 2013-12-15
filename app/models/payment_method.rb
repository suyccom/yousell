class PaymentMethod < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string, :unique
    voucher :boolean, :default => false
    timestamps
  end
  attr_accessible :name, :voucher

  # --- Relations --- #
  has_many :payments

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
