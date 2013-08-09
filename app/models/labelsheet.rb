class Labelsheet < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_printer    :string
    name_labelsheet :string
    rows            :integer
    columns         :integer
    top_margin      :float
    bottom_margin   :float
    left_margin     :float
    right_margin    :float
    timestamps
  end
  attr_accessible :name_printer, :name_labelsheet, :rows, :columns, :top_margin, :bottom_margin, :left_margin, :right_margin

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
