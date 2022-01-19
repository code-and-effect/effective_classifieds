# frozen_string_literal: true

Rails.application.routes.draw do
  mount EffectiveClassifieds::Engine => '/', as: 'effective_classifieds'
end

EffectiveClassifieds::Engine.routes.draw do
  # Public routes
  scope module: 'effective' do
    resources :classifieds, only: [:index, :show, :edit, :update]

    resources :classified_submissions, only: [:new, :show, :destroy] do
      resources :build, controller: :classified_submissions, only: [:show, :update]
    end

  end

  namespace :admin do
    resources :classifieds, except: [:show] do
      post :approve, on: :member
    end
  end

end
