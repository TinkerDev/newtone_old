class RecognitionController < ApplicationController
  def recognize
    audio = params[:audio]
    recognition = Recognition.new audio
    render :json => recognition.recognize
  end
end