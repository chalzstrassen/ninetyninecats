Rails.application.routes.draw do
  resources :cats
  resources :cat_rental_requests do
    patch 'approve'
    patch 'deny'
  end
end
