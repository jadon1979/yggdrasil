require 'rails_helper'

RSpec.describe Node, type: :model do
  it { should have_many(:birds) }
end