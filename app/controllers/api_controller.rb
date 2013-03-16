class ApiController < ApplicationController
  def query
    result = []
    render :js => result.to_json
  end
end