class CatRentalRequestsController < ApplicationController
  before_action :check_user, only: [:create, :approve, :deny]
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
    if new_request.save
      redirect_to cats_url
    else
      render html:"You have an error"
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
      
    end
end
