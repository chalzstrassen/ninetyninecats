class CatsController < ApplicationController
  before_action :own_cat, only: [:edit, :update]
  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find_by_id(params[:id])
    @rentals = @cat.cat_rental_requests.order(:start_date)
  end

  def create
    new_cat = Cat.new(cat_params)
    if current_user
      new_cat.user_id = current_user.id
      if new_cat.save
        redirect_to :cats
      else
        flash.now[:errors] = new_cat.errors.full_messages
        render :new
      end
    else
      flash[:notice] = "Please log in"
      redirect_to new_session_url
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

  def own_cat
    if current_user.nil?
      flash[:notice] = "Please log in"
      redirect_to new_session_url
    else
      cat = Cat.where(user_id: current_user.id)
               .where(id: params[:id])
      if cat.empty?
        flash[:notice] = "You do not own this cat."
        redirect_to cats_url
      end
    end
  end
end
