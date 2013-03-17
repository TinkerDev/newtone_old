class ApiController < ApplicationController
  def query
    query = params[:q]
    response = SolrQuery.do_solr_query query
    render :json => SolrQuery.human_response(response).to_json
  end
end