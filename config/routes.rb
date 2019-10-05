Rails.application.routes.draw do

	  get 'home/about'
	  #get 'users/index'
	  #get 'users/show'
	  # get 'books/new'
	  # get 'books/create'
	  # get 'books/index'
	  # get 'books/show'
	  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	root :to => 'home#top'

	devise_for :users
	  # resources :books, only: [:new, :create, :index, :show, :destroy]



	resources :books do
		# コントローラのidをリクエストに含めるため、単数形
		resource :book_comments, only: [:create, :edit, :update, :destroy]
	end

	resources :users, only: [:index, :show, :edit, :show, :update]

end


