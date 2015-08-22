Rails.application.routes.draw do
	root 'site#index'
	get '/:id/refresh' => 'site#refresh', as: :refresh, id: /.*/
	get '/:id' => 'site#result', as: :result, id: /.*/
end
