require 'rails_helper'

describe 'Nodes', type: :request do 

  before do 
    create(:node, node_id: 130)
    create(:node, node_id: 125, parent_id: 130)
    create(:node, node_id: 2820230, parent_id: 125)
    create(:node, node_id: 4430546, parent_id: 125)
    create(:node, node_id: 5497637, parent_id: 4430546)
  end 

  let!(:base_url) { '/api/v1/nodes' }

  [
    { node_a: 2820230, node_b: 2820230, lca: 2820230, root: 130, depth: 3 },
    { node_a: 5497637, node_b: 2820230, lca: 125, root: 130, depth: 2 },
    { node_a: 5497637, node_b: 130, lca: 130, root: 130, depth: 1 },
    { node_a: 5497637, node_b: 4430546, lca: 4430546, root: 130, depth: 3 },
    { node_a: 9, node_b: 4430546, lca: nil, root: nil, depth: nil },

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