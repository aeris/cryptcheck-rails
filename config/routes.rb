Rails.application.routes.draw do
  %i[https smtp xmpp tls ssh].each do |type|
    namespace type, id: /[^\/]+/ do
      get '/', action: :index
      get ':id/', action: :show, as: :show
      get ':id/refresh', action: :refresh, as: :refresh
    end
  end

  get 'help' => 'site#help'
  get 'about' => 'site#about'
  get 'ciphers' => 'site#ciphers'
  get 'suite' => 'site#suite_index'
  get 'suite/:id' => 'site#suite'
  post 'suite' => 'site#suite'
  root 'site#index'
  post '/' => 'site#check'

  get 'sites' => 'site#sites'

  %i[banks insurances gouv.fr].each do |name|
    get name, controller: :sites, action: name
  end

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
