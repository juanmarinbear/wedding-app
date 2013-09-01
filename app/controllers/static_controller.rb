class StaticController < ApplicationController
  def aboutus
  end

  def ceremony
  end

  def reception
  end

  def accommodations
  end

  def presents
    if params[:response]
      response = params[:response]
      @class = 'error'
      if response == 'success'
        @response = '¡Gracias por tu regalo!'
        @class = 'success'
      elsif response == 'failure'
        @response = '¡Hubo un error, intentan nuevamente!'
      elsif response == 'pending'
        @response = 'Estamos procesando tu pago...'
      end

    end

  end

end
