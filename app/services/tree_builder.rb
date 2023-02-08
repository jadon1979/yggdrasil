class TreeBuilder
  # Generate the tree and return a new instance 
  # 
  # @param [String] node_id
  # @params [Array] array of node_ids to stop processing at
  #
  # @return [Tree] the complete tree
  def self.generate(root_id, prune_at = [])
    data = Node.tree_by_root(root_id, prune_at)

    Yggdrasil.new(root_id, data)
  end 
end 

