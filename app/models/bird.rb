class Bird < ApplicationRecord
  belongs_to :node, primary_key: :node_id, optional: true

   # Find the root of any tree using 
  # a child node 
  #
  # @params [String] node_id 
  #
  # @return [Array]
  scope :birds_by_node_ids, ->(nodes) do 
    return if nodes.nil? || nodes.empty?

    ActiveRecord::Base.connection.exec_query(
      birds_by_node_ids_sql(nodes)
    )
  end 

  private 

  # The sql to recursively 
  # step through nodes until we locate 
  # the root node 
  #
  # @params[Array] nodes
  #
  # @return[Array]
  def self.birds_by_node_ids_sql(nodes = [])
    node_list = nodes.join(',')

    <<-SQL 
      with recursive treehouse as (
        SELECT * FROM nodes 
        WHERE node_id IN (#{node_list})

        UNION ALL

        SELECT nodes.* FROM nodes 
        JOIN treehouse ON treehouse.node_id = nodes.parent_id
        AND NOT treehouse.parent_id = treehouse.node_id
      )

      SELECT DISTINCT birds.* FROM birds 
      INNER JOIN treehouse ON birds.node_id = treehouse.node_id
    SQL
  end 
 
end
