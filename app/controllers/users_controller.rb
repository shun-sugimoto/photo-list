class UsersController < ApplicationController
    include ImagesHelper
    before_action :logged_in_user, only: [:show, :edit]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "ようこそ! #{@user.name}"
      redirect_to @user
    else
      flash.now[:alert] = "新規会員登録に失敗しました"
      render 'new'
    end
  end
    
  def show
    @user = User.find(params[:id])
    @images = @user.list_items
    @google_images = file_list
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
    
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password,:password_confirmation)
  end
end
