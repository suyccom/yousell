class VariationValue < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string
    code :string
    timestamps
  end
  attr_accessible :name, :code
  
  belongs_to :variation

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
