# frozen_string_literal: true

Rails.application.routes.draw do
  mount EffectiveClassifieds::Engine => '/', as: 'effective_classifieds'
end

EffectiveClassifieds::Engine.routes.draw do
  # Public routes
  scope module: 'effective' do
    resources :classifieds, only: [:show, :index]
  end

  namespace :admin do
    resources :classifieds, except: [:show]
  end

end
