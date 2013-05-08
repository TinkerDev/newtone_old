class RecognitionController < ApplicationController
  def recognize
    audio = params[:sample][:upload].tempfile.path
    tracks = Recognition.recognize(audio).map{|r| [Track.find(r.id), r._score]}
    response = nil
    if tracks.any?
      track = tracks.first[0]
      response = {:artist => track.artist.name, :track => track.title, :status => 1 }
    end
    render :json => response
  end
end
