class CatsController < ApplicationController
  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find_by_id(params[:id])
    @rentals = @cat.cat_rental_requests.order(:start_date)
  end

  def create
    new_cat = Cat.new(cat_params)
    if new_cat.save
      redirect_to :cats
    else
      raise "Error"
    end
  end

  def new
    @cat = Cat.new
  end

  def edit
    @cat = Cat.find_by_id(params[:id])
  end

  def update
    @cat = Cat.find_by_id(params[:id])
    @cat.update(cat_params)
    redirect_to cat_url(@cat)
  end

  private
  def cat_params
    params.require(:cat).permit(:name,
                                :sex,
                                :color,
                                :birth_date,
                                :description)
  end
end
