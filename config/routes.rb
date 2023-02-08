Rails.application.routes.draw do
  namespace :api, default: { format: 'json' } do 
    namespace :v1 do 
      resources :nodes do 
        collection do 
          get :common_ancestor
        end 
      end

      get '/birds', to: 'birds#index' 
    end 
  end 
end
