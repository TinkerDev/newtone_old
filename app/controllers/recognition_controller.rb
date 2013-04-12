class RecognitionController < ApplicationController
  def recognize
    audio = params[:sample][:upload].tempfile.path
    recognition = Recognition.new audio
    tracks = recognition.recognize
    response = nil
    if tracks.any?
      track = tracks.first[0]
      response = {:artist => track.artist.name, :track => track.title, :status => 1 }
    end
    render :json => response
  end
end
