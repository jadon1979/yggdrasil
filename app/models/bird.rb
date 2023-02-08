class Bird < ApplicationRecord
  belongs_to :node, primary_key: :node_id, optional: true
end
