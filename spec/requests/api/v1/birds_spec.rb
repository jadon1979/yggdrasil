require 'rails_helper'

describe 'Birds', type: :request do 

  let!(:node_a) { create(:node, :with_birds, node_id: 4430546, parent_id: 125) }
  let!(:node_b) { create(:node, :with_birds, node_id: 5497637, parent_id: 4430546) }

  before do 
    create(:node, node_id: 130)
    create(:node, node_id: 125, parent_id: 130)    
    create(:node, node_id: 2820230, parent_id: 125)
  end 

  let!(:base_url) { '/api/v1/birds' }

  it 'should return the root_id, lcv, and depth' do 
    get base_url, params: { ids: [ 4430546, 125 ]}

    response_body = JSON.parse(response.body, symbolize_names: true)
    ids = response_body[:ids]
    expect(ids.count).to eq(10)

    expect(node_a.birds.count).to eq(5)
    expect(node_b.birds.count).to eq(5)
  end 
end 