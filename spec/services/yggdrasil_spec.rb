require 'rails_helper'

describe Yggdrasil, type: :model do 
  before do 
    create(:node, node_id: 130)
    create(:node, node_id: 125, parent_id: 130)
    create(:node, node_id: 2820230, parent_id: 125)
    create(:node, node_id: 4430546, parent_id: 125)
    create(:node, node_id: 5497637, parent_id: 4430546)

    create(:node, node_id: 1953914, parent_id: nil )
    create(:node, node_id: 1954058, parent_id: 1953914 )
    create(:node, node_id: 1954069, parent_id: 1954058 )
    create(:node, node_id: 1954070, parent_id: 1954058 )
    create(:node, node_id: 1954090, parent_id: 1954069 )
    create(:node, node_id: 1954071, parent_id: 1954069 )
    create(:node, node_id: 2448694, parent_id: 1954070 )
    create(:node, node_id: 2898857, parent_id: 1954070 )
    create(:node, node_id: 3506451, parent_id: 1954070 )
    create(:node, node_id: 2448693, parent_id: 1954070 )
    create(:node, node_id: 1954163, parent_id: 1954070 )
    create(:node, node_id: 2671691, parent_id: 1954071 )
    create(:node, node_id: 1954101, parent_id: 1954071 )
    create(:node, node_id: 1954132, parent_id: 1954071 )
    create(:node, node_id: 2897017, parent_id: 1954071 )
    create(:node, node_id: 2448609, parent_id: 1954071 )
    create(:node, node_id: 2909271, parent_id: 1954071 ) 
  end 

  let(:data) {  Node.tree_by_root(130) }
  let(:tree) { described_class.new(130, data) }

  context 'build a tree' do
    it 'should build a tree' do 
      children = tree.root.children

      expect(tree.root.value).to eq(130)    
      expect(children.count).to eq(1)
      expect(children.first.value).to eq(125)
    end 

    it 'should build a bigger tree' do 
      data = Node.tree_by_root(1953914)
      tree = described_class.new(1953914, data)
      grand_child = tree.root.children.first

      expect(grand_child.children.count).to eq(2)
      expect(grand_child.value).to eq(1954058)
    end 
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

      expect(children[0]).to eq(3)
      expect(children[1]).to eq(4)
    end 
  end 
end 