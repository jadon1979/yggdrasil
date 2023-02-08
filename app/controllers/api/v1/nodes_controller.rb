class Api::V1::NodesController < ApplicationController
  before_action :validate_resource, only: [ :common_ancestor ]

  def common_ancestor
    render json: json_response(
      root_id: resource.root.value,
      lca: lowest_common_ancestor.value,
      depth: lowest_common_ancestor.depth
    )
  end 

  protected 

  def validate_resource 
    render json: json_response if resource.nil? || 
      lowest_common_ancestor.nil?
  end 

  def json_response(root_id: nil, lca: nil, depth: nil)
    {
      root_id: root_id, 
      lowest_common_ancestor: lca, 
      depth: depth 
    }
  end 

  def lowest_common_ancestor
    @lowest_common_ancestor ||= begin 
      node_a = resource.find_node_by_value(node_params[:a])
      node_b = resource.find_node_by_value(node_params[:b])

      resource.lowest_common_ancestor(resource.root, node_a, node_b)
    end 
  end 

  def resource
    @resource ||= 
      begin
        root = Node.verified_root_node(
          node_params[:a], node_params[:b]
        )

        TreeBuilder.generate(root) if root
      end 
  end 

  def node_params 
    params.permit(:a, :b)
  end 
end 