class CatRentalRequestsController < ApplicationController
  before_action :check_user, only: [:approve, :deny]
  def new
    @request = CatRentalRequest.new
    @cats = Cat.all
  end

  def index
    @requests = CatRentalRequest.all
    @cats = []
    @requests.each do |request|
      @cats << Cat.find_by_id(request.cat_id)
    end
  end

  def create
    new_request = CatRentalRequest.new(request_params)
    if current_user
      new_request.user_id = current_user.id 
      if new_request.save
        redirect_to cats_url
      else
        render html:"You have an error"
      end
    end
  end

  def approve
    request = CatRentalRequest.find_by_id(params[:cat_rental_request_id])
    request.approve!
    redirect_to cat_url(request.cat_id)
  end

  def deny
    request = CatRentalRequest.find_by_id(params[:cat_rental_request_id])
    request.deny!
    redirect_to cat_url(request.cat_id)
  end

  private
    def request_params
      params.require(:request).permit(:cat_id, :start_date, :end_date)
    end

    def check_user
      if current_user.nil?
        flash[:notice] = "Log in to see this page"
        redirect_to new_session_url
      else
        unless owned_cat?(current_cat)
          flash[:notice] = "You do not own this cat"
          redirect_to cats_url
        end
      end
    end

    def current_cat
      pending_request = CatRentalRequest.find_by_id(params[:cat_rental_request_id])
      Cat.find_by_id(pending_request.cat_id)
    end
end
