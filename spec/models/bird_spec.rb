require 'rails_helper'

RSpec.describe Bird, type: :model do
  it { should belong_to(:node).optional }
end