Rails.application.routes.draw do
	namespace :https, id: /[^\/]+/ do
		get ':id/', action: :show
		get ':id/refresh', action: :refresh, as: :refresh
	end

	namespace :smtp, id: /[^\/]+/ do
		get ':id/', action: :show
		get ':id/refresh', action: :refresh, as: :refresh
	end

	namespace :xmpp, id: /[^\/]+/ do
		get ':id/', action: :show
		get ':id/refresh', action: :refresh, as: :refresh
	end

	namespace :tls, id: /[^\/]+/ do
		get '/', action: :index
		get ':id/', action: :show
		get ':id/refresh', action: :refresh, as: :refresh
	end

	namespace :ssh, id: /[^\/]+/ do
		get '/', action: :index
		get ':id/', action: :show
		get ':id/refresh', action: :refresh, as: :refresh
	end

	root 'https#index'
	get '/ciphers' => 'site#ciphers'
end
