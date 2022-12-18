Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "hotel#home", constraints: {domain: 'ddzhusu.com'}
  root "ziliao#home"
  # ziliao
  get "/ziliao/download/:id", to: "ziliao#download"
  # account
  get "/account/sign_in", to: "account#sign_in"
  post "/account/sign_in", to: "account#do_sign_in"
  get "/account/sign_up", to: "account#sign_up"
  post "/account/sign_up", to: "account#do_sign_up"
  get "/account/password_new", to: "account#password_new"
  post "/account/password_new", to: "account#do_password_new"
  get "/account/profile", to: "account#profile"
  post "/account/profile", to: "account#update_profile"
  get "/account/send_code", to: "account#send_code"

  # task
  get "/task", to: "task#task_list"
  get "/task/create_task_kuaidi", to: "task#create_task_kuaidi"
  post "/task/create_task_kuaidi", to: "task#do_create_task_kuaidi"
  get "/task/show_task_kuaidi", to: "task#show_task_kuaidi"
  get "/task/create_task_daike", to: "task#create_task_daike"
  post "/task/create_task_daike", to: "task#do_create_task_daike"
  get "/task/show_task_daike", to: "task#show_task_daike"
  get "/task/create_task_jianzhi", to: "task#create_task_jianzhi"
  post "/task/create_task_jianzhi", to: "task#do_create_task_jianzhi"
  get "/task/show_task_jianzhi", to: "task#show_task_jianzhi"
  get "/task/create_task_ershou", to: "task#create_task_ershou"
  post "/task/create_task_ershou", to: "task#do_create_task_ershou"
  get "/task/show_task_ershou", to: "task#show_task_ershou"
  get "/task/create_task_other", to: "task#create_task_other"
  post "/task/create_task_other", to: "task#do_create_task_other"
  get "/task/show_task_other", to: "task#show_task_other"
  get "/task/:id", to: "task#show", id: /\d+/
  get "/task/:id/take", to: "task#take", id: /\d+/
  get "/task/:id/delete", to: "task#delete", id: /\d+/
  get "/task/:id/confirm", to: "task#confirm", id: /\d+/

  # feedback
  get "/feedback", to: "account#feedback"
  post "/feedback", to: "account#do_feedback"

  # student
  get "/student/action", to: "account#student"

  # hotel
  get "/hotel/:md5", to: "hotel#show"
  get "/hotel_country/:country_short", to: "hotel#hotel_country"
  get "/hotel_region/:region_short", to: "hotel#hotel_region"
  get "/hotel_city/:city_short", to: "hotel#hotel_city"
  get ':controller(/:action(/:id))'
end
