require 'sidekiq/web'

Rails.application.routes.draw do

  get 'welcome/index'

  resources :faqs, only: [:index]

  mount Ckeditor::Engine => '/ckeditor'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  mount TkmlAuth::Engine => "/auth", :as => "auth_engine"
  # You can have the root of your site routed with "root"

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'sidekiq' && password == 'w63qvyovgxpN'
  end
  mount Sidekiq::Web, at: '/sidekiq'


  root 'welcome#index'

  resources :schematics, :only => :index do
    get "print", :on => :collection
  end
  get '/schematics/print/*app', to: 'schematics#print'
  get '/schematics/*app', to: 'schematics#index'

  resources :resources

  resources :programs do
    resources :resources
    post "resources/:id", to: "resources#update"
    member do
      post "add_color_blocks", to: "programs#add_color_blocks", as: :add_color_blocks
      post "add_geographies", to: "programs#add_geographies", as: :add_geographies
      delete "remove_color_block", to: "programs#remove_color_block", as: :remove_color_block
      post "update_status", to: "programs#update_status", as: :update_status
    end
  end
  post 'programs/filter_programs' => 'programs#filter_programs'

  # Agency specific routes
  resources :agencies, path: "manage-agencies" do
    get :autocomplete_user_email, :on => :collection
    member do
      post "add_geographies_to_agency", to: "agencies#add_geographies_to_agency", as: :add_geographies
      post "add_user_to_agency", to: "agencies#add_user_to_agency", as: :add_user_to_agency
      delete "destroy_all_geographies_from_agency", to: "agencies#destroy_all_geographies_from_agency", as: :destroy_all_geographies_from_agency
      delete "destroy_agency_geography/:geography_id", to: "agencies#destroy_agency_geography", as: :destroy_agency_geography
      delete "destroy_agency_user/:user_id", to: "agencies#destroy_agency_user", as: :destroy_agency_user
      get "manage_geographies", path: "co-ops"
      get "manage_users", path: "users"
    end
  end

  resources :color_blocks, path: "color-blocks"
  resources :geographies, path: "co-ops" do
    get "children", to: "geographies#find_children", as: :children
    post "assign_user", to: "geographies#add_user"
    get :set_selected_id, on: :collection
  end

  resources :messages, path: "message-center" do
    get :autocomplete_user_email, :on => :collection
    get :autocomplete_contact_list_name, :on => :collection
    resources :resources
  end

  # resource :calendars do
  #   get "events/show", to: "events#show"
  #   get "events/show_modal", to: "events#show_modal"
  #   resources :events
  # end

  resources :calendars, only: [:index]
  get 'calendars/grid_view', to: 'calendars#grid_view'

  resources :users do
    resources :contact_lists
    get :role_stub_set, on: :collection
  end

  resources :zones, only: [:index, :edit, :update]
  resources :documents, only: [:index, :edit, :update]
  get 'documents/rejoin_programs', to: 'documents#rejoin_programs'
  resources :killswitches, only: [:index, :edit, :update]
  resources :date_types, only: [:index, :edit, :update]

  resources :alerts, except: [:destroy]
  resources :moments, except: [:destroy]

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :schematics do
        resources :geographies_schematics
        resources :pdfs
        resources :layouts
        resources :documents, path: :document, only: [:index] do
          resources :notes
          resources :programs, only: [:index], controller: "document/programs"

          collection do
            resources :elements, only: [:index, :show, :update]
          end
        end
      end
      resources :geographies do
        get "list", on: :collection
        get "drop_down", on: :collection
      end
      resources :contact_list_users
      get "users/search", to: "users#search", as: :user_search
      get "contact_lists/search_contact_lists/:user_id", to: "contact_lists#search_contact_lists", as: :search_contact_lists
      post "users/get_claims", to: "users#get_claims", as: :get_user_claims
      resources :users do
        resources :contact_lists
      end
      get "dam_assets/notify", to: "dam_assets#notify"
      get "dam_caches/assets", to: "dam_caches/assets#index"
      post "dam_caches/assets", to: "dam_caches/assets#update"
      put "dam_caches/assets/:id", to: "dam_caches/assets#update"
      get "dam_caches/assets/:id", to: "dam_caches/assets#show"
      patch "dam_caches/assets/:id", to: "dam_caches/assets#update"
      get "dam_caches/assets/clear", to: "dam_caches/assets#clear"
      get "dam_caches/asset_types", to: "dam_caches/asset_types#index"
      get "dam_caches/asset_types/:id", to: "dam_caches/asset_types#show"
      get "dam_caches/asset_types/clear", to: "dam_caches/asset_types#clear"
      resources :programs, only: [:index, :show]
    end
  end

  resources :lookup_tables, except: [:destroy] do
    post 'import',  on: :collection
    get  'new_import', on: :collection
    post 'user_changes_sync', on: :collection
    post 'smart_sync', on: :collection
    post 'total_sync', on: :collection
    put  'archive', on: :member

    resources :lookup_table_rows, except: [:destroy] do
      put 'archive', on: :member
    end
  end

  resources :traffic_reports, except: [:destroy] do
    get 'archive', on: :member
  end

  get '/diagnostics/', to: 'diagnostics#index'
end
