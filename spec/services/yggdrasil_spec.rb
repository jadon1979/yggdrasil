require 'rails_helper'

describe Yggdrasil, type: :model do 
  before do 
    create(:node, node_id: 130)
    create(:node, node_id: 125, parent_id: 130)
    create(:node, node_id: 2820230, parent_id: 125)
    create(:node, node_id: 4430546, parent_id: 125)
    create(:node, node_id: 5497637, parent_id: 4430546)
  end 

  let(:data) {  Node.tree_by_root(130) }
  let(:tree) { described_class.new(130, data) }

  it 'should build a tree' do 
    expect(tree.root.value).to eq(130)
    expect(tree.root.left.value).to eq(125)
    expect(tree.root.right.value).to eq(Float::INFINITY)
  end 

  # Test the lowest_common_ancestor method using varios scenarios
  [
    { node_a: 2820230, node_b: 2820230, lca: 2820230, root: 130 },
    { node_a: 5497637, node_b: 2820230, lca: 125, root: 130 },
    { node_a: 5497637, node_b: 130, lca: 130, root: 130 },
    { node_a: 5497637, node_b: 4430546, lca: 4430546, root: 130 },
  ].each do |scenario|
    context '#lowest_common_ancestor' do 
      let(:start_node) { tree.root }
      let(:node_a) { tree.find_node_by_value(scenario[:node_a]) }
      let(:node_b) { tree.find_node_by_value(scenario[:node_b]) }

      it 'should return the lowest common ancestor' do 
        lca = tree.lowest_common_ancestor(start_node, node_a, node_b)
        expect(lca.value).to eq(scenario[:lca])
      end 

      it 'should return nil if no lowest common ancestor is found' do 
        node_a = tree.find_node_by_value(9)
        node_b = tree.find_node_by_value(4430546)

        lca = tree.lowest_common_ancestor(tree.root, node_a, node_b)
        expect(lca).to be_nil
      end 
    end 
  end 

  context '#find_node_by_value' do 
    it 'should find a node by node_id' do 
      expect(tree.find_node_by_value(130).depth).to eq(1)
      expect(tree.find_node_by_value(125).depth).to eq(2)
      expect(tree.find_node_by_value(5497637).depth).to eq(4)
      expect(tree.find_node_by_value(9)).to be_nil
    end 
  end 

  context '#build_node' do 
    it 'should build a tree node' do 
      new_tree = tree.build_node(4430546)
      
      expect(new_tree.value).to eq(4430546)
      expect(new_tree.left.value).to eq(5497637)
      expect(new_tree.right.value).to eq(Float::INFINITY)
    end 
  end 

  context '#matched_node?' do 
    it 'should verify if nodes match' do 
      node_a = tree.find_node_by_value(125)
      node_b = tree.find_node_by_value(130)
      node_c = tree.find_node_by_value(5497637)

      expect(tree.matched_node?(tree.root, node_a, node_b)).to eq(true)
      expect(tree.matched_node?(tree.root, node_a, node_c)).to eq(false)
    end 
  end 

  context '#node_children' do 
    before do 
      create(:node, node_id: 1)
      create(:node, node_id: 2, parent_id: 1)
      create(:node, node_id: 4, parent_id: 2)
      create(:node, node_id: 3, parent_id: 2)
    end 

    let(:data) {  Node.tree_by_root(1) }
    let(:tree) { described_class.new(1, data) }
      
    it 'should give a sorted list of child nodes' do 
      children = tree.node_children(2)

      expect(children[0]['node_id']).to eq(3)
      expect(children[1]['node_id']).to eq(4)
    end 
  end 
end 