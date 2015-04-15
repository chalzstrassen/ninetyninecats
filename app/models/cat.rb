class Cat < ActiveRecord::Base
  validates :sex, inclusion: %w(M F m f)
  validates :color, inclusion: %w(blue black white red gray yellow brown), presence: true
  validates :name, presence: true

  belongs_to :owner,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :cat_rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :cat_id,
    primary_key: :id,
    dependent: :destroy
end
