class UploadersController < ApplicationController
  include ApplicationHelper
  before_action :set_uploader, only: [:show, :edit, :update, :destroy]
  before_action :get_admin, except:[:new, :create]


  # GET /uploaders
  # GET /uploaders.json
  def index
    @uploaders = Uploader.all
  end

  # GET /uploaders/1
  # GET /uploaders/1.json
  def show
  end

  # GET /uploaders/new
  def new
    @uploader = Uploader.new
    @uploader.images.build
    @name = session[:name]
    @lastname = session[:lastname]
    @email = session[:email]
  end

  # GET /uploaders/1/edit
  def edit
  end

  # POST /uploaders
  # POST /uploaders.json
  def create
    @uploader = Uploader.find_or_initialize_by(email:uploader_params[:email])

    if @uploader.new_record?
      @uploader.attributes = uploader_params
    else
      @uploader.attributes = {images_attributes:uploader_params[:images_attributes]}
    end

    respond_to do |format|
      if @uploader.save
        session[:name] = @uploader.name
        session[:lastname] = @uploader.lastname
        session[:email] = @uploader.email
        format.html { redirect_to new_uploader_path, notice: '¡Gracias por subir tus fotos!.  En cuanto las aprobemos aparecerán en esta página.' }
        format.json { render action: 'show', status: :created, location: @uploader }
      else
        format.html { render action: 'new' }
        format.json { render json: @uploader.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploaders/1
  # PATCH/PUT /uploaders/1.json
  def update
    respond_to do |format|
      if @uploader.update(uploader_params)
        format.html { redirect_to @uploader, notice: 'Uploader was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @uploader.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploaders/1
  # DELETE /uploaders/1.json
  def destroy
    @uploader.destroy
    respond_to do |format|
      format.html { redirect_to uploaders_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_uploader
      @uploader = Uploader.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def uploader_params
      params.require(:uploader).permit(:name, :lastname, :email, images_attributes:[:photo, :tag_list])
    end
end
