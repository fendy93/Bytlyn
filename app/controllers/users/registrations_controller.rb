class Users::RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create_user, :create_rest, :new_user, :new_rest]
before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new_user
    build_resource({})
    set_minimum_password_length
    yield resource if block_given?
    respond_with self.resource
  end
  def new_rest
    build_resource({})
    set_minimum_password_length
    yield resource if block_given?
    respond_with self.resource
  end


  # POST /resource
  def create_user
    @this_param = sign_up_params
    @this_param[:rest] = false
    build_resource(@this_param)

    # save the new customer to database User
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      flash[:notice] = flash[:notice].to_a.concat resource.errors.full_messages
      redirect_to signup_user_path
    end
    if resource.save
      # save the new restaurant to database Restaurant
      param = {user_id: resource.id, phone_number: 00000}
      @restaurant = Customer.new(param)
      @restaurant.save
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      flash[:errors] = flash[:errors].to_a.concat resource.errors.full_messages
      # respond_with resource
      redirect_to setting_path
    end
  end

  def create_rest
    @this_param = sign_up_params
    @this_param[:rest] = true
    build_resource(@this_param)

    # save the new restaurant to database User
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: restaurant_new_path
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: restaurant_new_path
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      flash[:notice] = flash[:notice].to_a.concat resource.errors.full_messages
      redirect_to signup_restaurant_path
    end

    # if resource.save
    #   # save the new restaurant to database Restaurant
    #   param = {user_id: resource.id}
    #   @restaurant = Restaurant.new(param)
    #   @restaurant.save
    # end
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
  # def destroy
  #   User.find_by_id(resource.id).destroy
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
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << :name 
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:account_update) << :avatar
    devise_parameter_sanitizer.for(:account_update) << :braintree_customer_id
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
