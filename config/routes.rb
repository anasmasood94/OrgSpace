Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  
  root "organizations#index"
  
  resources :organizations do
    resources :memberships, except: [:show]
    resources :roles, except: [:show]
    resources :posts
  end
  
  resources :roles, only: [:index]
  
  # Parental consent routes
  resource :parental_consent, only: [:new, :create]
  
  # Consent approval routes (no authentication required)
  get 'consent/approve/:id', to: 'consent_approvals#approve', as: :approve_parental_consent
  get 'consent/deny/:id', to: 'consent_approvals#deny', as: :deny_parental_consent
  get 'parental_consent/pending', to: 'parental_consents#pending', as: :pending_parental_consent
  get 'parental_consent/denied', to: 'parental_consents#denied', as: :parental_consent_denied
  # Age-based participation routes
  namespace :age_groups do
    get 'minors', to: 'participation#minors'
    get 'adults', to: 'participation#adults'
  end
  
  # Analytics routes
  get 'analytics', to: 'analytics#index'
  get 'organizations/:id/analytics', to: 'organizations#analytics', as: :organization_analytics
end