Rails.application.routes.draw do
  
  get 'hello_world', to: 'hello_world#index'
  namespace :api do
    namespace :v1 do

      resources :users do
        collection do
          get 'profile/:username', to: 'users#details'
          get :profile
        end
        member do
          put :block
          put :activate
        end
      end

      resources :roles do
        collection do
          post :create
          delete :destroy
          get :users_list
        end
      end

    end
  end
  
  post   'login'   =>  'sessions#create'
  delete 'logout'  =>  'sessions#destroy'

  root 'docs#index'
  get '/docs', to: 'docs#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
