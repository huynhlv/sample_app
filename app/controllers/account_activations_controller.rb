class AccountActivationsController < ApplicationController
  before_action :load_email, only: :edit

  def edit
    if !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t ".account_activated"
      redirect_to @user
    else
      flash[:danger] = t ".invalid_activation"
      redirect_to root_path
    end
  end

  private

  def load_email
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t ".email_not_found"
    redirect_to :root
  end
end
