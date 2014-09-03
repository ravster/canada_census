class Api::V1::CensusTractsController < ApplicationController
  def index
    render json: CensusTract.return_tracts_as_json_string(params).to_s
  end
end
