class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      user_activated_or_not user
    else
      flash.now[:danger] = t "user.invalid_email_pass"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def user_activated_or_not user
    if user.activated?
      log_in user
      remember_or_forget user
      redirect_back_or user
    else
      message = t "user.check_you_email"
      flash[:warning] = message
      redirect_to root_path
    end
  end

  def remember_or_forget user
    if params[:session][:remember_me] == Settings.app.yes_remmeber
      remember(user)
    else
      forget(user)
    end
  end
end
