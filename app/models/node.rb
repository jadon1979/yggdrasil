class Node < ApplicationRecord
  has_many :birds, dependent: :destroy, primary_key: :node_id, foreign_key: :node_id

  # Find the root of any tree using 
  # a child node 
  #
  # @params [String] node_id 
  #
  # @return [Array]
  scope :root_by_id, ->(node_id) do 
    return if node_id.nil?

    ActiveRecord::Base.connection.exec_query(
      root_by_id_sql(node_id)
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
  # @param[String] node_a the first node to check
  # @param[String] node_b the second node to check
  # 
  # @return [String, Boolean] the proper root node or false
  def self.verified_root_node(node_a, node_b)
    root_a = Node.root_by_id(node_a)&.first
    root_b = Node.root_by_id(node_b)&.first
    missing_nodes = root_a.nil? || root_b.nil?
    
    return false if missing_nodes || root_a['node_id'] != root_b['node_id']
    
    root_a['node_id'] 
  end 

  private 

  # The necessary sql to recursively 
  # step through nodes until we locate 
  # the root node 
  #
  # @params[String] node_id
  #
  # @return[String]
  def self.root_by_id_sql(node_id)
    <<-SQL 
      with recursive treehouse as (
        SELECT * FROM nodes 
        WHERE node_id = #{node_id}

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
