class GuestsController < ApplicationController
  include ApplicationHelper

  before_action :set_guest, only: [:show, :edit, :update, :destroy]

  skip_before_action :verify_authenticity_token

  before_action :get_admin, except:[:new, :create, :mercado_pago, :mercado_response]

  # GET /guests
  # GET /guests.json
  def index
    @guests = Guest.all
    @total = @guests.count
    guests = @guests.dup.to_a
    @guests_with_companion = []
    @guests.each do |guest|
      unless guest.companion.nil?
        @guests_with_companion << guest
        guests.delete(guest)
        guests.delete(guest.companion)
      end
    end
    @guests = guests

    @dishes = Guest::DISHES
    @dishes_total = []
    @dishes.each do |dish|
      total = Guest.where(dish:dish).size
      @dishes_total << {dish:dish, total:total}
    end
  end

  # GET /guests/1
  # GET /guests/1.json
  def show
  end

  # GET /guests/new
  def new
    @guest = Guest.new
    @guest.build_companion
  end

  # GET /guests/1/edit
  def edit
    @companion = @guest.companion
    @plus_one =  nil
    @minus_one =  nil
    if @companion
      @plus_one = 'hidden'
      @minus_one = 'visible'
    end
  end

  # POST /guests
  # POST /guests.json
  def create
    @guest = Guest.new(guest_params)
    respond_to do |format|
      if @guest.save
        format.html { redirect_to @guest, notice: 'Guest was successfully created.' }
        format.json { render action: 'show', status: :created, location: @guest }
      else
        format.html { render action: 'new' }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guests/1
  # PATCH/PUT /guests/1.json
  def update
    respond_to do |format|

      unless @guest.companion_id.nil?
          unless guest_params[:companion_attributes]
            params[:guest][:companion_attributes] = { id: @guest.companion_id, _destroy: '1' }
          end
      end

      if @guest.update(guest_params)

        format.html { redirect_to @guest, notice: 'Guest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guests/1
  # DELETE /guests/1.json
  def destroy
    @guest.destroy
    respond_to do |format|
      format.html { redirect_to guests_url }
      format.json { head :no_content }
    end
  end


  def mercado_pago

    value = params[:value]

    dateTime = DateTime.now.strftime('%d%m%Y%H%M%S')
    client_id = '2267111060447384'
    client_secret = 'Wl7ZDdEsP8YewntOkXdE2ldfLNz5nLV7'

    if (session[:access_token])
        access_token = session[:access_token]
    else
      @authentication = HTTParty.post("https://api.mercadolibre.com/oauth/token", :headers => {'Accept' => 'application/json', 'Content-Type' => 'application/x-www-form-urlencoded' }, 
      :body => "grant_type=client_credentials&client_id=#{client_id}&client_secret=#{client_secret}" )

      access_token =  @authentication.parsed_response["access_token"]
      session[:access_token] = access_token
    end

    if session[:init_point]
      
      item = "{
                'items': [
                    {
                    'id': regalo_#{dateTime},
                    'title': 'Regalo Juan & Dulce',
                    'description': 'Regalo Juan & Dulce',
                    'quantity': 1,
                    'unit_price': #{value},
                    'currency_id': MXN,
                    'picture_url': 'https://www.mercadopago.com/org-img/MP3/home/logomp3.gif'
                    }
                ]
            }"
      @response = HTTParty.put("https://api.mercadolibre.com/checkout/preferences/#{session[:reference_id]}?access_token=#{access_token}", :headers => {'Accept' => 'application/json', 'Content-Type' => 'application/json' }, :body => item)
    else
      item = "{
                'items': [
                    {
                    'id': regalo_#{dateTime},
                    'title': 'Regalo Juan & Dulce',
                    'description': 'Regalo Juan & Dulce',
                    'quantity': 1,
                    'unit_price': #{value},
                    'currency_id': MXN,
                    'picture_url': 'https://www.mercadopago.com/org-img/MP3/home/logomp3.gif'
                    }
                ],
                'external_reference': 'reaglo_#{dateTime}',
                'back_urls': {
                    'success': '#{root_url}/presents?response=success',
                    'failure': '#{root_url}/presents?response=failure',
                    'pending': '#{root_url}/presents?response=pending'
                }
            }"

      @response = HTTParty.post("https://api.mercadolibre.com/checkout/preferences?access_token=#{access_token}", :headers => {'Header' => 'application/json', 'Content-Type' => 'application/json' }, :body => item)
      init_point =  @response.parsed_response["init_point"]
      reference_id =  @response.parsed_response["id"]
      session[:init_point] = init_point
      session[:reference_id] = reference_id


    end

    button = "<a id='payment-button' href='#{session[:init_point]}' name='MP-Checkout' class='lightblue-ar-s-ov' mp-mode='modal' onreturn='execute_my_onreturn'>Pagar</a><script type='text/javascript' src='http://mp-tools.mlstatic.com/buttons/render.js'></script></div>"

    respond_to do |format|
      format.json { render json: {response:@response.to_json, button:button }}
    end
    
  end

  def mercado_response
    respond_to do |format|
      format.json { render json: {status:200}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guest
      @guest = Guest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def guest_params
      params.require(:guest).permit(:name, :lastname, :email, :mobile, :facebook, :twitter, :instagram, :dish, :companion_id, companion_attributes:[:name, :lastname, :email, :mobile, :facebook, :twitter, :instagram, :dish, :id, :_destroy])
    end
end
