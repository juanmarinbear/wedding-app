class Image < ActiveRecord::Base
  has_many :image_tags
  has_many :tags, through: :image_tags
  has_one :uploader

  has_attached_file :photo
  validates_attachment_content_type :photo, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'
  
  after_save :set_tags

  def tag_list
    @tags
  end

  def tag_list=(tag_list)
    @tags = tag_list.split(',')
  end


  private
  def set_tags
    if @tags
      @tags.each do |tag|
        @tag = Tag.find_or_create_by_name(tag)
        self.tags << @tag
      end
    end
  end


end
