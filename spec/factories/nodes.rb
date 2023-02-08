FactoryBot.define do  
  factory :node do 
    node_id { nil }
    parent_id { nil }

    trait :with_birds do
      after(:create) do |node|
        create_list(:bird, 5, node: node)
      end      
    end 
  end 
end 