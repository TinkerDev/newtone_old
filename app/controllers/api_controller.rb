class ApiController < ApplicationController
  def query
    query = params[:q]
    results = Recognition.recognize_by_code query
    result = if results.any?
               track = Track.find(results.first.id)
               {:artist => track.artist.name, :track => track.title, :status => 1 }
             else
               nil
             end
    render :json => result.to_json
  end
end