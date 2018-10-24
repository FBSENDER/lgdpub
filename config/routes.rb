Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"
  # account
  get "/account/sign_in", to: "account#sign_in"
  post "/account/sign_in", to: "account#do_sign_in"
  get "/account/sign_up", to: "account#sign_up"
  post "/account/sign_up", to: "account#do_sign_up"
  get "/account/password_new", to: "account#password_new"
  post "/account/password_new", to: "account#do_password_new"
  get "/account/profile", to: "account#profile"
  post "/account/profile", to: "account#update_profile"

  # task
  get "/task", to: "task#task_list"
  get "/task/create_task_kuaidi", to: "task#create_task_kuaidi"
  post "/task/create_task_kuaidi", to: "task#do_create_task_kuaidi"
  get "/task/show_task_kuaidi", to: "task#show_task_kuaidi"
  get "/task/create_task_daike", to: "task#create_task_daike"
  post "/task/create_task_daike", to: "task#do_create_task_daike"
  get "/task/show_task_daike", to: "task#show_task_daike"
  get "/task/:id", to: "task#show", id: /\d+/
  get "/task/:id/take", to: "task#take", id: /\d+/
  get "/task/:id/delete", to: "task#delete", id: /\d+/
  get "/task/:id/confirm", to: "task#confirm", id: /\d+/

  # feedback
  get "/feedback", to: "account#feedback"
  post "/feedback", to: "account#do_feedback"

  get ':controller(/:action(/:id))'
end
