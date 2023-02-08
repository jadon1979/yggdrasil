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

    expect(tree.root.value).to eq(130)
    expect(tree.root.left.value).to eq(125)
    expect(tree.root.right.value).to eq(Float::INFINITY)
  end 

  it 'should prune the tree' do 
    tree = TreeBuilder.generate(130, [125])
    left_node = tree.root.left

    expect(left_node.left).to be_nil
    expect(left_node.right).to be_nil
  end 
 
end 