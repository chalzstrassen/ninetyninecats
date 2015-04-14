class CatRentalRequestsController < ApplicationController
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
      redirect_to cat_rental_requests_url
    else
      render html:"You have an error"
    end
  end

  private
    def request_params
      params.require(:request).permit(:cat_id, :start_date, :end_date)
    end
end
