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

	get 'help' => 'site#help'
	get 'about' => 'site#about'
	get 'ciphers' => 'site#ciphers'
	get 'suite' => 'site#suite_index'
	get 'suite/:id' => 'site#suite'
	post 'suite' => 'site#suite'
	root 'site#index'
	post '/' => 'site#check'

	get 'sites' => 'site#sites'
end
