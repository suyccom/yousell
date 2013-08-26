class User < ActiveRecord::Base

  hobo_user_model # Don't put anything above this

  fields do
    name                :string, :required, :unique
    email_address       :email_address, :login => true
    administrator       :boolean, :default => false
    language            :string, :default => "en"
    last_added_products :string
    company_name        :string
    company_address     :text
    timestamps
  end
  
  # Save the last added products as JSON
  serialize :last_added_products, JSON

  
  belongs_to :current_warehouse, :class_name => 'Warehouse'
  
  attr_accessible :name, :email_address, :password, :password_confirmation, 
    :current_password, :current_warehouse, :current_warehouse_id, :company_name, 
    :company_address

  # This gives admin rights and an :active state to the first sign-up.
  # Just remove it if you don't want that
  before_create do |user|
    if !Rails.env.test? && user.class.count == 0
      user.administrator = true
      user.state = "active"
    end
  end
  
  def self.current_user
    Thread.current[:current_user]
  end

  def self.current_user=(usr)
    Thread.current[:current_user] = usr
  end


  # --- Signup lifecycle --- #

  lifecycle do

    state :active, :default => true

    create :signup, :available_to => "Guest",
           :params => [:name, :email_address, :password, :password_confirmation],
           :become => :active

    transition :request_password_reset, { :active => :active }, :new_key => true do
      UserMailer.forgot_password(self, lifecycle.key).deliver
    end

    transition :reset_password, { :active => :active }, :available_to => :key_holder,
               :params => [ :password, :password_confirmation ]

  end

  # --- Permissions --- #

  def create_permitted?
    # Only the initial admin user can be created
    self.class.count == 0
  end

  def update_permitted?
    acting_user.administrator? ||
      (acting_user == self && only_changed?(:email_address, :crypted_password,
                                            :current_password, :password, :password_confirmation, 
                                            :current_warehouse, :current_warehouse_id, 
                                            :company_name, :company_address))
    # Note: crypted_password has attr_protected so although it is permitted to change, it cannot be changed
    # directly from a form submission.
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end
end
