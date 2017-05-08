Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "users#index"

  resources :users, param: :permalink, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      resources :debit_cards, only: [:index, :show, :new, :create, :edit, :update] do
        post :make_payment, on: :member
      end
    end
  end

end
