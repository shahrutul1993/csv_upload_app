Rails.application.routes.draw do
	root to: 'products#index'
  resources :products do
  	 collection { post :import }
  end
end
