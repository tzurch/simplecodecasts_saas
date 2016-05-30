class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find( params[:id] )   
  end 
  
  def upgrade
    customer = Stripe::Customer.all.find { |u| u.email == current_user.email }
    customer.plan = params[:plan_id]
    customer.save
    current_user.update(plan_id: params[:plan_id])
    flash[:success] = "Succesfull update to your account"
    redirect_to :back
  end
  
end 