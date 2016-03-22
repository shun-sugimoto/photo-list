class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:info] = "ようこそ! #{@user.name}"
      redirect_to @user
    else
      flash.now[:alert] = "新規会員登録に失敗しました"
      render 'new'
    end
  end
    
  def show
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password,:password_confirmation)
  end
end
