Yousell::Application.routes.draw do
  match ENV['RAILS_RELATIVE_URL_ROOT'] => 'front#index' if ENV['RAILS_RELATIVE_URL_ROOT']

  root :to => 'sales#new'

  match 'users/:id/reset_password_from_email/:key' => 'users#reset_password', :as => 'reset_password_from_email'

  match 'users/:id/accept_invitation_from_email/:key' => 'users#accept_invitation', :as => 'accept_invitation_from_email'

  match 'users/:id/activate_from_email/:key' => 'users#activate', :as => 'activate_from_email'

  match 'search' => 'front#search', :as => 'site_search'
  
  match 'sales/:id/cancel' => 'sales#cancel'

  # Products
  match 'products/:id/product_labels' => 'products#product_labels'
  match 'products/last_products_labels' => 'products#last_products_labels'
  match 'products/multiple_changes' => 'products#multiple_changes'
  match 'product_types/new_from_barcode' => 'product_types#new_from_barcode'
  match 'product_types/transfer' => 'product_types#transfer'
  match 'search_products' => 'front#search_products'
  match 'product_types/rellenar_textarea' => 'product_types#rellenar_textarea'

  # Warehouses
  match 'refill_lines' => 'warehouses#refill_lines'
  match 'change_amount' => 'warehouses#change_amount'

  # Pending day sales
  match 'pending_day_sales' => 'sales#pending_day_sales'
  match 'pending_day_sales/:sales_date' => 'sales#destroy_pending_day_sales'
  match 'pending_sales' => 'sales#pending_sales'
  match 'pending_sales/:sales_id' => 'sales#destroy_pending_sales'
  match 'sales/new_sale' => 'sales#new_sale'

  # Payments
  match 'payments/at_sale' => 'payments#at_sale'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
