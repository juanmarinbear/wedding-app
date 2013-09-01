class ImageTag < ActiveRecord::Base
  belongs_to :image
  belongs_to :tag

  validates_presence_of :image, :tag
end