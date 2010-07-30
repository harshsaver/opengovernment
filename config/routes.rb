OpenGov::Application.routes.draw do |map|
  match '/search' => 'districts#search', :as => 'search'
  match '/states/ca/subscriptions' => 'states#subscribe', :as => 'state_subscriptions'
  match '/us_map(.:format)' => 'home#us_map', :as => 'us_map', :defaults => {:format => "html"}

  resources :districts, :only => [:show]
  resources :sigs, :only => [:index, :show]
  resources :issues, :only => [:index, :show]

  resources :bills, :only => [:show], :path => '/states/:state_id/sessions/:session/bills' do
    member do
      get :major_actions
    end
    shallow do
      resources :actions, :only => [:show]
    end
  end

  resources :people, :only => [:show, :index] do
    member do
      get :sponsored_bills
      get :votes
    end
  end

  resources :states, :only => [:show] do
    get :search, :on => :member
    resources :votes, :only => [:show]
    resources :bills, :only => [:index]
    resources :people, :only => [:index], :as => 'reps'

    resources :committees, :only => [:show] do
      collection do
        get :upper
        get :lower
        get :joint
      end
    end
  end

  namespace :admin do
    resources :states
    resources :people
    resources :issues, :only => [:create, :index] do
      collection do
        get :bills
        get :categories
      end
    end
    match '/issues/update' =>  'issues#update', :as => 'update_issues'
  end

  root :to => "home#index"
#  Clearance::Routes.draw(map)
end
