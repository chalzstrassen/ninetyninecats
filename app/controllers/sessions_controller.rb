class SessionsController < ApplicationController
  before_action :redirect_to_index
  skip_before_action :redirect_to_index, only: [:destroy]

  def new

  end

  def create
    user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if user.nil?
      flash[:notice] = "Log in failed"
      redirect_to new_session_url
    else
      login!(user)
      redirect_to cats_url
    end

  end

  def destroy
    logout!
    redirect_to new_session_url
  end

  def redirect_to_index
    if current_user
      redirect_to cats_url
    end
  end
end
