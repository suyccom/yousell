# Application configuration constants
DOCUMENTATION_PATH = Rails.root.join('app','documentation').to_s
TICKETS_PATH = Rails.root.join(DOCUMENTATION_PATH,'tickets').to_s
PRINT_LABELS_COMMAND = "lp "
PRINT_TICKETS_COMMAND = "lp -o cpi=18 -o lpi=10 "
SHOP_NAME = 'Shop name'
