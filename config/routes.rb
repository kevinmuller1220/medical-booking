Rails.application.routes.draw do

  resources :doctors, path: "/doctors", controller: 'users/doctors' do
    get :import_from_google_calendar, on: :member, path: '/import_from_google_calendar', as: :import_from_google_calendar
    get :disconnect_identity, on: :member, path: '/disconnect_identity', as: :disconnect_identity
    get :booked_hours, on: :member, path: '/booked_hours', as: :booked_hours
  end

  resources :patients, path: "/patients", controller: 'users/patients', except: [:index] do
    get :disconnect_identity, on: :member, path: '/disconnect_identity', as: :disconnect_identity
  end

  resources :appointments, except: [:index, :show, :edit] do
    post :approve, on: :member, path: '/approve', as: :approve
    post :cancel, on: :member, path: '/cancel', as: :cancel
  end

  devise_for :patient_users, controllers: {:sessions  => "users/sessions"}#, skip: :sessions
  devise_for :doctor_users, controllers: {:sessions  => "users/sessions"}#, skip: :sessions
  devise_for :users, :controllers => {:sessions  => "users/sessions"}, :skip => [:registrations]

  match "/auth/:action/callback", :to => "users/omniauth_callbacks", as: :omniauth_callback, via: [:get, :post]
  match "/auth/:action", :to => "users/omniauth_callbacks", as: :omniauth_authorize, via: [:get, :post]

  devise_scope :user do
    get "/users/logout" => "users/sessions#destroy", as: :users_logout
  end

  root 'home#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
