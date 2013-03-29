class RecognitionController < ApplicationController
  def recognize
    audio = params[:sample][:upload].tempfile.path
    recognition = Recognition.new audio
    tracks = recognition.recognize
    track = tracks[0].first
    response = tracks.any? ? {:artist => track.artist, :track => track.title, :status => 1 } : nil
    render :json => response
  end
end
