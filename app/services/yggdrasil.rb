class Yggdrasil
  attr_accessor :root, :nodes

  class TreeNode 
    attr_accessor :value, :depth, :children, :path

    def initialize(value, depth)
      @value = value
      @depth = depth
      @children ||= []
      @path ||= []
    end
  end 

  def initialize(root_id, tree_data)
    @root_id = root_id
    @tree_data = tree_data.to_a
    @root ||= build_node(@root_id)
  end 

  # Find the lowest common ancestor (recursion)
  # 
  # @param [String] value - the node value to find
  # @param [TreeNode] node - node to start at
  #
  # @return [TreeNode] the matched node
  def find_node_by_value(value, node = root)
    return nil if node.nil?
    
    return node if node.value == value.to_i

    node.children.each do |child|
      found_node = find_node_by_value(value, child)
      return found_node if found_node
    end 

    nil
  end
  
  # Find the lowest common ancestor
  # 
  # @param [TreeNode] node - node to start at
  # @param [TreeNode] node_a - node to search
  # @param [TreeNode] node_b - node to search
  #
  # @return [TreeNode] the lowest common ancestor node 
  def lowest_common_ancestor(node, node_a, node_b)
    return nil unless !!node && !!node_a && !!node_b
    
    node_id = (node_a.path & node_b.path).last
    
    return nil if node_id.nil?

    find_node_by_value(node_id)
  end 

  # Check if the current node matches node_a or node_b
  # 
  # @param [TreeNode] the current node
  # @param [TreeNode] node_a is the first value node
  # @param [TreeNode] node_b is the second value node
  #
  # @return [TreeNode] the complete tree
  def matched_node?(node, node_a, node_b)
    node == node_a || node == node_b 
  end 

  # Build the full tree from the given root node  
  # 
  # @param [String] node_id
  # @param [Integer] depth - the current depth of the tree
  #
  # @return [TreeNode] the complete tree
  def build_node(node_id, path = [], depth = 1)
    return TreeNode.new(Float::INFINITY, depth) if node_id.nil?

    node = TreeNode.new(node_id, depth)
    node.path = path << node_id

    children = node_children(node_id)

    return node if children.empty?

    node.children = children.map do |c| 
      build_node(c, node.path.dup, depth + 1)
    end 
    
    node
  end

  # Find the children belonging to this node  
  # and then sort them by their node_id so 
  # that all lower values are on the left 
  #
  # @param [String] node_id
  #
  # @return [Array] childnodes of the given node_id
  def node_children(node_id)
    children = @tree_data.select do |d| 
      d['parent_id'] == node_id
    end.sort_by { |a| a['node_id'] }

    children.map { |n| n['node_id'] }
  end  
end 
