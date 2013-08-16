class Labelsheet < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_printer    :string, :required
    name_labelsheet :string, :required
    rows            :integer, :required
    columns         :integer, :required
    top_margin      :float, :required
    bottom_margin   :float, :required
    left_margin     :float, :required
    right_margin    :float, :required
    timestamps
  end
  attr_accessible :name_printer, :name_labelsheet, :rows, :columns, :top_margin, :bottom_margin, :left_margin, :right_margin
  
  def name
    "#{name_printer} #{name_labelsheet}"
  end
  
  # -- Check the number format -- #
  def top_margin=(input)
    write_attribute(:top_margin, check_number_format(input))
  end
  def bottom_margin=(input)
    write_attribute(:bottom_margin, check_number_format(input))
  end
  def left_margin=(input)
    write_attribute(:left_margin, check_number_format(input))
  end
  def right_margin=(input)
    write_attribute(:right_margin, check_number_format(input))
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
  
  protected
 
  def check_number_format(string)
    string.gsub!(/[^\d.,]/,'')          # Replace all Currency Symbols, Letters and -- from the string
 
    if string =~ /^.*[\.,]\d{1}$/       # If string ends in a single digit (e.g. ,2)
      string = string + "0"             # make it ,20 in order for the result to be in "cents"
    end
 
    unless string =~ /^.*[\.,]\d{2}$/   # If does not end in ,00 / .00 then
      string = string + "00"            # add trailing 00 to turn it into cents
    end
 
    string.gsub!(/[\.,]/,'')            # Replace all (.) and (,) so the string result becomes in "cents"  
    string.to_f / 100                   # Let to_float do the rest
  end

end
