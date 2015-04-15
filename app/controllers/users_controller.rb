class UsersController < ApplicationController
  before_action :redirect_to_index

  def new

  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "User has been created"
      redirect_to cats_url
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to new_user_url
    end
  end

  private
    def user_params
      params.require(:user).permit(:user_name, :password)
    end

    def redirect_to_index
      if current_user
        redirect_to cats_url
      end
    end
end
