class UsersController < ApplicationController
  before_action :load_user, except: %i(create new index)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def show; end

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.app.page_user.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controllers.users_controller.please_check"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controllers.users_controller.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.users_controller.user_deleted"
    else
      flash[:danger] = t "controllers.users_controller.user_delete_error"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "controllers.users_controller.user_not_found"
    redirect_to :root
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controllers.users_controller.please_login"
    redirect_to login_url
  end

  # Confirms the correct user.
  def correct_user
    redirect_to root_url unless current_user? @user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
