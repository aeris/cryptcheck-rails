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

	get 'ciphers' => 'site#ciphers'
	get 'suite' => 'site#suite_index'
	post 'suite' => 'site#suite'
	root 'site#index'
	post '/' => 'site#check'
end
