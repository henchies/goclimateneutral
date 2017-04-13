class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]



  # GET /resource/sign_up
  def new
    @plan = params[:plan] || 5
    super
  end

  # POST /resource
  def create
    require "stripe"

    @plan = params[:user][:plan] || 5

    begin
      
      plan_id = "climate_offset_" + @plan.to_s + "_monthly"
      plan_name = "Climate Offset " + @plan.to_s + " Monthly"

      customer = Stripe::Customer.create(
          :email => params[:user][:email],
          :source  => params[:stripeToken]
      )
      params[:user][:stripe_customer_id] = customer.id

      begin
        plan = Stripe::Plan.retrieve(plan_id)
      rescue
        
        begin 
          plan = Stripe::Plan.create(
            :name => plan_name,
            :id => plan_id,
            :interval => "month",
            :currency => "usd",
            :amount => @plan.to_s + "00"
          )
        rescue
          flash[:error] = e.message
            redirect_to new_subscrition_path
          end
      end

      Stripe::Subscription.create(
        :customer => customer.id,
        :plan => plan.id,
      )

    rescue Stripe::CardError => e
        flash[:error] = e.message
        redirect_to new_subscription_path
    end

    super

  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
