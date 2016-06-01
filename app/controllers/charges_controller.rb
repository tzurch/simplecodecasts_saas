class ChargesController < ApplicationController
   before_filter :authenticate_user!
   
   def show
      @amount = current_user.plan.price.to_int
      @coupon = Coupon.find_by_code(current_user.coupon)
      
      if @coupon
        @discount_amount = (@amount * @coupon.discount_percent) / 100
        @charged_amount = @amount - @discount_amount
      end
      
      @charged_amount ||= @amount
      
      
   end
end
