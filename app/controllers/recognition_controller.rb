class RecognitionController < ApplicationController
  def recognize
    audio = params[:sample][:upload].tempfile.path
    recognition = Recognition.new audio
    render :json => {:artist => "the Chemodan", :track => "Zeliboba IS DEAD", :status => 1 } #recognition.friendly_recognize
  end
end
