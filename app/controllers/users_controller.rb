class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "User has been created"
      redirect_to cats_url
    else
      flash.now[:errors] = @user.errors.full_messages
      # redirect_to new_user_url
    end
  end

  private
    def user_params
      params.require(:user).permit(:user_name, :password)
    end
end
