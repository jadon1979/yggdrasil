require 'rails_helper'

describe TreeBuilder, type: :model do 
  before do 
    create(:node, node_id: 130, parent_id: nil)
    create(:node, node_id: 125, parent_id: 130)
    create(:node, node_id: 2820230, parent_id: 125)
    create(:node, node_id: 4430546, parent_id: 125)
    create(:node, node_id: 5497637, parent_id: 4430546)
  end 

  let(:data) {  Node.tree_by_root(130) }

  it 'should generate a tree' do 
    tree = TreeBuilder.generate(130)
    child = tree.root.children.first
    grand_child = child.children.first

    expect(tree.root.value).to eq(130)
    expect(child.value).to eq(125)
    expect(grand_child.value).to eq(2820230)
  end 

  it 'should prune the tree' do 
    tree = TreeBuilder.generate(130, [125])
    children = tree.root.children
    expect(children.count).to eq(1)
  end 
 
end 