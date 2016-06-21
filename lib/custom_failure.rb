class CustomFailure < Devise::FailureApp
  def redirect_url
    sign_in_path
  end
  def respond
    if http_auth?
      http_auth
    else
      flash[:danger] = "Email or password is incorrect"
      redirect
    end
  end
end