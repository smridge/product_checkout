Rails.application.routes.draw do
  resources :transactions, only: [:index, :create]

  get "/:org_slug/balance", to: "balances#show"
end
