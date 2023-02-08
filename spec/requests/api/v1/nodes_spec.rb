require 'rails_helper'

describe 'Nodes', type: :request do 

  before do 
    # tree 1
    create(:node, node_id: 130)
    create(:node, node_id: 125, parent_id: 130)
    create(:node, node_id: 2820230, parent_id: 125)
    create(:node, node_id: 4430546, parent_id: 125)
    create(:node, node_id: 5497637, parent_id: 4430546)

    # tree 2
    create(:node, node_id: 100)
    create(:node, node_id: 101, parent_id: 100)
    create(:node, node_id: 102, parent_id: 100)
    create(:node, node_id: 103, parent_id: 101)
    create(:node, node_id: 104, parent_id: 101)
    create(:node, node_id: 105, parent_id: 102)
    create(:node, node_id: 106, parent_id: 102)
    create(:node, node_id: 107, parent_id: 105)
    create(:node, node_id: 108, parent_id: 105)
    create(:node, node_id: 109, parent_id: 109)        
  end 

  let!(:base_url) { '/api/v1/nodes' }

  # GET /api/v1/nodes/common_ancestor
  # Test the common_ancestor action using varios scenarios
  [
    { node_a: 2820230, node_b: 2820230, lca: 2820230, root: 130, depth: 3 },
    { node_a: 5497637, node_b: 2820230, lca: 125, root: 130, depth: 2 },
    { node_a: 5497637, node_b: 130, lca: 130, root: 130, depth: 1 },
    { node_a: 5497637, node_b: 4430546, lca: 4430546, root: 130, depth: 3 },
    { node_a: 9, node_b: 4430546, lca: nil, root: nil, depth: nil },

    { node_a: 104, node_b: 107, lca: 100, root: 100, depth: 1 },
    { node_a: 108, node_b: 107, lca: 105, root: 100, depth: 3 },
    { node_a: 103, node_b: 104, lca: 101, root: 100, depth: 2 },
    { node_a: 109, node_b: 109, lca: nil, root: nil, depth: nil },    
  ].each do |scenario|
    context '#common_ancestor' do 
      it 'should return the root_id, lcv, and depth' do 
        get "#{base_url}/common_ancestor", params: { 
          a: scenario[:node_a], 
          b: scenario[:node_b], 
        }

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({
          root_id: scenario[:root],
          lowest_common_ancestor: scenario[:lca],
          depth: scenario[:depth]
        })
      end 
    end 
  end 
end 