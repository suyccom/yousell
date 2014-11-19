# Application configuration constants
DOCUMENTATION_PATH = Rails.root.join('app','documentation').to_s
TICKETS_PATH = Rails.root.join(DOCUMENTATION_PATH,'tickets').to_s
PRINT_LABELS_COMMAND = "lp "
PRINT_TICKETS_COMMAND = "lp -o cpi=18 -o lpi=10 "
BARCODE_FORMAT = [
  {:type => :provider,  :chars => 2},
  {:type => :variation, :chars => 1, :name => 'Type'},
  {:type => :code,      :chars => 4},
  {:type => :variation, :chars => 3, :name => 'Color'},
  {:type => :variation, :chars => 2, :name => 'Size'}
]
SHOP_NAME = 'Shop name'
