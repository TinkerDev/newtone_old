class RecognitionController < ApplicationController
  def recognize
    audio = params[:sample][:upload]
    recognition = Recognition.new audio
    render :json => recognition.recognize
  end
end
