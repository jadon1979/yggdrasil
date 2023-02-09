class Node < ApplicationRecord
  has_many :birds, dependent: :destroy, primary_key: :node_id

  # Find the root of any tree matching 
  # the child nodes
  #
  # @params [Array] node_ids
  #
  # @return [Array]
  scope :root_by_ids, ->(node_ids = []) do 
    return if node_ids.nil? || node_ids.empty?

    ActiveRecord::Base.connection.exec_query(
      root_by_ids_sql(node_ids)
    )
  end 

  # Build the entire tree by the root node id
  #
  # @params [String] root_id 
  # @params [Array] array of node_ids to stop at
  #
  # @return [Array]
  scope :tree_by_root, ->(root_id, prune_at = []) do 
    return if root_id.nil?

    ActiveRecord::Base.connection.exec_query(
      tree_by_root_sql(root_id, prune_at)
    )
  end 

  # Guard against bad data by verifying  
  # that the root exists for both nodes 
  # and that the roots are equal.  
  # 
  # @param[Array] node_a the first node to check
  # @param[String] node_b the second node to check
  # 
  # @return [String, Boolean] the proper root node or false
  def self.verified_root_node(node_a, node_b)
    roots = Node.root_by_ids([ node_a, node_b ])
    
    # Check if we don't have a root or where the nodes are not apart 
    # of the same tree.
    invalid_root = roots.empty? || (roots.count == 1 && node_a != node_b) || roots.uniq.count > 1
    
    return false if invalid_root
    
    roots.first['node_id'] 
  end 

  private 

  # The necessary sql to recursively 
  # step through nodes until we locate 
  # the root node 
  #
  # @params[Array] node_ids
  #
  # @return[String]
  def self.root_by_ids_sql(node_ids = [])
    <<-SQL 
      with recursive treehouse as (
        SELECT * FROM nodes 
        WHERE node_id IN (#{node_ids.join(',')})

        UNION ALL

        SELECT nodes.* FROM nodes 
        JOIN treehouse ON treehouse.parent_id = nodes.node_id
        AND NOT treehouse.parent_id = treehouse.node_id
      )

      SELECT * FROM treehouse 
      WHERE parent_id IS NULL 
      ORDER BY parent_id 
    SQL
  end 

  # The sql to recursively 
  # build a tree from the root node
  #
  # @params[String] root_id
  # @params[Array] array of node_ids to stop at
  #
  # @return[String]
  def self.tree_by_root_sql(root_id, prune_at)
    prune_list = "AND NOT parent_id IN (#{prune_at.join(',')})" if prune_at.any?
    
    <<-SQL 
      with recursive treehouse as (
        SELECT * FROM nodes 
        WHERE node_id = #{root_id}

        UNION ALL

        SELECT nodes.* FROM nodes 
        JOIN treehouse ON treehouse.node_id = nodes.parent_id
      )

      SELECT * FROM treehouse 
      WHERE NOT node_id = parent_id
      #{prune_list}
      ORDER BY parent_id 
    SQL
  end 
end
