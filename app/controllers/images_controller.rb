class ImagesController < ApplicationController
  include ApplicationHelper
  skip_before_action :verify_authenticity_token
  before_action :set_image, only: [:show, :edit, :update, :destroy]


  # GET /images
  # GET /images.json
  def index
    @images = get_approved
    @left_images = []
    @right_images = []
    @center_images = []
    counter = 0
    @images.each do |image|
      counter+=1
      if counter == 1
        @left_images << image
      elsif counter ==2
        @center_images << image
      elsif counter ==3
        counter = 0
        @right_images << image
      end
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
    @im
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)
    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render action: 'show', status: :created, location: @image }
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end

  def images_status
    @images = params[:content]

    if @images
      @images.each do |key, image|
        @image = Image.find(image[:id])

        if image[:approved] == 'on'
          @image.update_attributes(approved: true)
        elsif
          @image.update_attributes(approved: false)
        end
      end
    end

    redirect_to '/admin-content'
  end

  def admin_content
    approved = params[:approved]

    if approved == "true"
      @images = get_approved
      @approved_flag = true
    else
      @images = get_not_approved
      @approved_flag = false
    end

    @left_images = []
    @right_images = []
    @center_images = []
    counter = 0
    @total_counter = 0
    @images.each do |image|
      counter+=1
      if counter == 1
        @left_images << image
      elsif counter ==2
        @center_images << image
      elsif counter ==3
        counter = 0
        @right_images << image
      end
    end
  end

  private

    def get_approved
      Image.where(approved: true)
    end

    def get_not_approved
      Image.where(approved: false)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:approved, :photo, :tag_list)
    end
end
