class Cat < ActiveRecord::Base
  validates :sex, inclusion: %w(M F m f)
  validates :color, inclusion: %w(blue black white red gray yellow brown), presence: true
  validates :name, presence: true


end
