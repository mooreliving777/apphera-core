Rails.application.routes.draw do

  resources :posts
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'home#index'
  get 'privacy' => 'home#privacy'
  
  
  # mount ActionCable.server => '/cable'
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    omniauth_callbacks: 'users/omniauth_callbacks',
    passwords: "users/passwords",
    invitations: 'users/invitations'
  }
  devise_scope :user do
    get '/revoke_login/:uid/:provider' => 'users/omniauth_callbacks#revoke_login', as: :revoke_login
  end
  resources :companies, except: %i[new create] do
    collection do
      get :signup, path: 'sign_up'
      post :register
    end
  end

  post 'file/receive' => 'file#receive'
  get '/dashboard' => 'home#dashboard', as: :dashboard

  namespace :api, defaults: {format: 'json'} do

    namespace :v1 do
      # match "/404" => "errors#not_found"
      # match "/500" => "errors#exception"
      #root to: 'dash#index', default: {format: 'html'}
      get 'items/:account_id' => 'items#account_items'
      resources :accounts
      resources :users
      get 'analytics/campaign_date_ranges', to: 'analytics#campaign_date_ranges'
      get 'analytics/campaign_results/:account_id/:campaign_id', to: 'analytics#campaign_results'
      get 'analytics/ranges', to: 'analytics#analytics_range'
      delete 'analytics/ranges/:range_id', to: 'analytics#delete_range'
      put 'analytics/ranges/:range_id', to: 'analytics#update_range'
      post 'analytics/ranges', to: 'analytics#create_analytics_range'
      get 'analytics/twitter_campaign/:account_id/:campaign_id', to: 'analytics#get_twitter_campaign_calculations'
      get 'analytics/twitter_campaign_calculations/:account_id', to: 'analytics#twitter_campaign_calculations'
      get 'analytics/timezones', to: 'analytics#timezones'
      get 'analytics/twitter_ad_hoc/:keyword_id/:from/:to/:time_zone', to: 'analytics#twitter_analytics_ad_hoc'
      get 'analytics/twitter_campaign_ad_hoc/:campaign_id/:from/:to/:time_zone', to: 'analytics#twitter_by_campaign_ad_hoc'
      get 'analytics/:account_id', to: 'analytics#index'
      post 'analytics/:account_id', to: 'analytics#create'
      post 'analytics/:account_id/query/:query_id', to: 'analytics#query'
      get 'analytics/tweets_hourly_distribution/:keyword_id/:from/:to/:time_zone', to: 'analytics#tweets_hourly_distribution'
      post 'organizations/create/:account_id' => 'organizations#create'
      get 'organizations/:account_id/:organization_id', to: 'organizations#show'
      get 'organizations/:account_id' => 'organizations#index'
      put 'organizations/:account_id/:organization_id' => 'organizations#update'
      get 'aggregate_results/:acc/:orgid' => 'aggregate_results#show'
      resources :aggregate_results # using Apphera aggregation framework
      get 'campaigns/:account_id' => 'campaigns#index'
      post 'campaigns/:account_id' => 'campaigns#create'
      post 'campaigns/:account_id/keywords/:campaign_id' => 'campaigns#add_keywords'
      put 'campaigns/:account_id/:campaign_id/edit' => 'campaigns#edit'
      put 'campaigns/:account_id/keywords/:campaign_id' => 'campaigns#update_keywords'
      delete 'campaigns/:account_id/:campaign_id' => 'campaigns#destroy'
      get 'categories/:id' => 'categories#show'
      get 'categories' => 'categories#index'
      resources :countries
      get 'competitors/:acc/:id' => 'competitors#show'
      get 'reviews/crawl/:account_id/:organization_id' => 'reviews#crawl'
      post 'facebook/pages/settings' => 'facebook#pages_settings'
      post 'facebook/post', to: 'facebook#facebook_post'
      post 'facebook/pages/credentials', to: 'facebook#set_page_credentials'
      post 'facebook/pages/credentials_short', to: 'facebook#set_page_credentials_short_token'
      post 'facebook/pages/credentials/:account_id/:c_user_id', to: 'facebook#set_page_credentials_from_c_user'
      post 'facebook/pages/post', to: 'facebook#page_post'
      post 'facebook/users/credentials', to: 'facebook#set_credentials'
      get 'facebook/users/credentials/:account_id', to: 'facebook#get_all_credentials'
      get 'facebook/users/credentials/:account_id/:c_user_id', to: 'facebook#get_credentials'
      delete 'facebook/users/credentials/:account_id/:c_user_id', to: 'facebook#delete_credentials'
      get 'facebook/pages/credentials/:account_id', to: 'facebook#get_page_credentials'
      get 'facebook/pages/credentials/:account_id/:c_user_id', to: 'facebook#get_page_credentials_by_user'
      delete 'facebook/pages/credentials/:account_id/:fb_id', to: 'facebook#delete_page_credentials'
      get 'facebook/pages/read_wall/:account_id/:fb_id', to: 'facebook#read_wall'
      get 'facebook/pages/read_wall_comments/:account_id/:fb_id', to: 'facebook#read_wall_comments'
      delete 'facebook/pages/posts/:account_id/:fb_id/:post_id', to: 'facebook#delete_post'
      post 'facebook/pages/posts/comment', to: 'facebook#post_comment'
      post 'facebook/pages/comments/reply', to: 'facebook#reply_to_comment'
      delete 'facebook/pages/comments/:account_id/:fb_id/:comment_id', to: 'facebook#delete_comment'
      get 'rankings/:id' => 'rankings#index'
      get 'reviewers/:id/reviews' => 'reviewers#reviewer_reviews'
      get 'reviewers/:id' => "reviewers#show"
      get 'reviews/:account_id/:organization_id' => 'reviews#show'
      resources :content_providers
      resources :geocomps
resources :contents  
    get 'sentiments/languages' => 'sentiments#languages'
      get 'sentiments/:lang/:body' => 'sentiments#show'
      get 'senti/positive' => 'senti#positive'
      get 'senti/negative' => 'senti#negative'
      get 'senti/neutral' => 'senti#neutral'
      post 'senti/classify' => 'senti#classify'
      post 'senti/train' => 'senti#train'
      post 'senti/untrain' => 'senti#untrain'
      post 'sentiments' => 'sentiments#complex'
      post 'behavior/classify' => 'behavior#classify'
      post 'behavior/train' => 'behavior#train'
      post 'behavior/untrain' => 'behavior#untrain'
      get 'tracks' => 'tracks#index'
      get 'tracks/:keyword_id/facebook' => 'tracks#facebook'
      get 'tracks/:keyword_id/youtube' => 'tracks#youtube'
      get 'tracks/:keyword_id/instagram' => 'tracks#instagram'
      get 'tracks/:keyword_id/search/:market' => 'tracks#search'
      get 'tracks/:keyword_id/twitter' => 'tracks#twitter'

      resources :schedules
      # post 'keywords/:account_id/:keyword' => 'keywords#create_for_account'
      # post 'keywords/:acc/:org/:keyword' => 'keywords#create'
      post 'keywords/:account_id' => 'keywords#create_for_account'
      #post 'keywords/:acc/:org/' => 'keywords#create'
      delete 'keywords/:acc/:org/:keyword_id' => 'keywords#delete_association'
      get 'keywords/:acc/' => 'keywords#keywords_by_account'
      get 'keywords/refresh/:keyword_id' => 'keywords#refresh_aggregates'
      get 'keywords/:acc/:org' => 'keywords#index'
      get 'links/:acc/:org' => 'links#index'
      get 'markets' => 'markets#index'
      resources :instagram
      get 'google_plus/people/search/:p' => 'google_plus#people_search'
      #get 'google_plus/:acc/people/search/:p' => 'google_plus#people_search'
      get 'google_plus/people/:id/track' => 'google_plus#people_track'
      get 'google_plus/people/:id/activities' => 'google_plus#people_activities'
      get 'google_plus/people/:id/untrack' => 'google_plus#people_untrack'
      get 'google_plus/activity/:id/plusones' => 'google_plus#activity_plusones'
      get 'google_plus/activity/:id/reshares' => 'google_plus#activity_reshares'
      get 'google_plus/activity/:id/comments' => 'google_plus#activity_comments'
      resources :google
      get 'twitter/app/credentials' => 'twitter#get_app_credentials'
      post 'twitter/app/credentials' => 'twitter#set_app_credentials'
      delete 'twitter/app/credentials' => 'twitter#delete_app_credentials'
      put 'twitter/app/credentials' => 'twitter#update_app_credentials'
      post 'twitter/tweet' => 'twitter#tweet'
      post 'twitter/credentials' => 'twitter#set_credentials'
      get 'twitter/user/:user_id/tweets' => 'twitter#user_tweets'
      get 'twitter/search/:search' => 'twitter#tweet_search'
      get 'twitter/followers_average' => 'twitter#followers_average'
      get 'twitter/followers_count' => 'twitter#followers_count'
      get 'twitter/users_count' => 'twitter#users_count'
      get 'twitter/newest' => 'twitter#newest'
      get 'twitter/timeline/:c_user_id' => 'twitter#read_timeline'
      resources :twitter #wrap apphera twitter API
    
      resources :apps, only: %i[index]
    end
  end
end
