class Users::RegistrationsController < Devise:: RegistrationsController
  before_filter :select_plan, only: :new
  
    
  def create
    super do |resource|  
      if params[:plan]
        resource.plan_id = params[:plan]
        resource.stripe_card_token = params["stripeToken"]
        resource.save_with_payment
        resource.save
      end
    end
  end
  
 
  private
    def select_plan
      unless params[:plan] && (params[:plan] == '1' || params[:plan] == '2')
        flash[:notice] = "Please select a membership plan to sign up."
        redirect_to root_url
      end  
    end

#end last placement

#stripe coupon controller

  def create
    # Amount in cents
    @amount = 1000
    @final_amount = @amount
  
    @code = params[:couponCode]
  
    if !@code.blank?
      @discount = get_discount(@code)
  
      if @discount.nil?
        flash[:error] = 'Coupon code is not valid or expired.'
        redirect_to new_charge_path
        return
      else
        @discount_amount = @amount * @discount
        @final_amount = @amount - @discount_amount.to_i
      end
  
      charge_metadata = {
        :coupon_code => @code,
        :coupon_discount => (@discount * 100).to_s + '%'
      }
    end
  
    charge_metadata ||= {}
  
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )
    Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @final_amount,
    :description => 'Rails Stripe customer',
    :currency    => 'usd',
    :metadata    => charge_metadata
  )
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
  
 private

  COUPONS = {
    'RAVINGSAVINGS' => 0.10,
    'SUMMERSALE' => 0.05,
    'FoundersClub' => 0.50
  }
  
  def get_discount(code)
    # Normalize user input
    code = code.gsub(/ +/, '')
    code = code.upcase
    COUPONS[code]
  end
  
end  