class Api::V1::BirdsController < ApplicationController

  # GET /api/v1/birds
  # returns the formatted response for the birds by node ids 
  #
  # @return[JSON] the formatted birds_by_node_ids_response
  #
  # Example:
  #  { ids: [1, 2, 3, 4] }
  def index
    render json: { ids: collection.map { |b| b.inspect; b['id'] }}
  end 

  protected 

  def collection
    @collection ||= Bird.birds_by_node_ids(bird_params[:ids])
  end 

  def bird_params 
    params.permit(ids: [])
  end 
end 