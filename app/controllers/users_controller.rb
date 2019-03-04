class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.page(params[:page]).per Settings.pages_limit
  end

  def show
    @user = User.find_by id: params[:id]
  end

  def edit; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t "register_success"
      redirect_to root_path
    else
      flash[:success] = t "register_failed"
      render :new
    end
  end

  def update
    @user = User.find_by id: params[:id]

    if @user.update_attributes user_params
      flash[:success] = t "update_success"
      redirect_to @user
    else
      flash[:danger] = t "not_update"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name,
      :email, :password, :password_confirmations, :address, :phone
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless @user.current_user? current_user
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".plog"
    redirect_to login_url
  end
end
