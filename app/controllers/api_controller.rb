class ApiController < ApplicationController
  def query
    query = params[:q]
    response = Solr.search query
    render :json => Solr.human_response(response).to_json
  end
end