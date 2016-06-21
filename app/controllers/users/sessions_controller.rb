class Users::SessionsController < Devise::SessionsController
before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    # render text: "HAI"
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: profile_path
  end
  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    # flash[:notice] = "Email or password is incorrect"
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    # devise_parameter_sanitizer.for(:sign_in) << :attribute
  end
end
