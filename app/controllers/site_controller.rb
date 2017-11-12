require 'simpleidn'

class SiteController < ApplicationController
	def check
		host, port, type = params[:host], params[:port], params[:type]

		host = SimpleIDN.to_ascii host.downcase
		if host.blank? or /[^a-zA-Z0-9.-]/ =~ host
			flash[:danger] = "Hôte #{host} invalide"
			render :index
			return
		end

		unless port.blank?
			port = port.to_i
			unless (1..65535).include? port
				flash[:danger] = "Port #{port} invalide"
				render :index
				return
			end
			host = "#{host}:#{port}"
		end

		unless %w(https smtp xmpp tls ssh).include? type
			flash[:danger] = "Type #{type} invalide"
			render :index
			return
		end

		redirect_to "/#{type}/#{host}"
	end

	def suite
		@suite = params[:id] || params.require(:suite)
		@ciphers = CryptCheck::Tls::Cipher.list @suite
	end

	def help

	end

	def about

	end
end
