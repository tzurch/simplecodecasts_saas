class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :plan    
  has_one :profile
  attr_accessor :stripe_card_token
  
  def save_with_payment coupon
    #if valid?
      data = {email: email, plan: plan_id, source: stripe_card_token}
      data.merge!(coupon: coupon) if coupon.present?
      customer = Stripe::Customer.create(data)
      self.stripe_customer_token = customer.id
      self.coupon = coupon
      save!
      logger.info "customer created"
    #send
  end
end
