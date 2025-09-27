Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :doctors, only: %i[index show create update destroy]
      resources :patients, only: %i[index show create update destroy] do
        resources :bmr, only: %i[index create], controller: "bmrs"
        get 'bmi', to: 'bmi_proxy#show'
      end
    end
  end
end
