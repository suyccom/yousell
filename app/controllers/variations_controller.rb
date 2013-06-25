class VariationsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def create
    hobo_create do
      redirect_to('/variations') if this.valid?
    end
  end

  def update
    hobo_update do
      redirect_to('/variations') if this.valid?
    end
  end

end
