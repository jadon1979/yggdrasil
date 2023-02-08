class Api::V1::NodesController < ApplicationController
  before_action :validate_resource, only: [ :common_ancestor ]

  # GET /api/v1/nodes/common_ancestor
  # returns the formatted response for the lowest common ancestor 
  #
  # @return[JSON] the formatted common_ancestor_response
  #
  # Example:
  #  { root_id: 1, lowest_common_ancestor: 3, depth: 2 }
  #  { root_id: null, lowest_common_ancestor: null, depth: null }
  def common_ancestor
    render json: common_ancestor_response(
      root_id: resource.root.value,
      lca: lowest_common_ancestor.value,
      depth: lowest_common_ancestor.depth
    )
  end 

  protected 

  # Check if the resource and lowest_common_ancestor are present 
  # and render the default response if not
  # @return[Void]
  def validate_resource 
    render json: common_ancestor_response if resource.nil? || 
      lowest_common_ancestor.nil?
  end 

  # Format the response for the common_ancestor action
  #
  # @params[Integer] root_id
  # @params[Integer] lca
  # @params[Integer] depth
  #
  # @return[Hash]
  def common_ancestor_response(root_id: nil, lca: nil, depth: nil)
    {
      root_id: root_id, 
      lowest_common_ancestor: lca, 
      depth: depth 
    }
  end 

  # Find the lowest common ancestor for the supplied params
  #
  # @return[Node]
  def lowest_common_ancestor
    @lowest_common_ancestor ||= begin 
      node_a = resource.find_node_by_value(node_params[:a])
      node_b = resource.find_node_by_value(node_params[:b])

      resource.lowest_common_ancestor(resource.root, node_a, node_b)
    end 
  end 

  # Generate the tree resource from the supplied params
  def resource
    @resource ||= 
      begin
        root = Node.verified_root_node(node_params[:a], node_params[:b])

        TreeBuilder.generate(root) if root
      end 
  end 

  def node_params 
    params.permit(:a, :b)
  end 
end 