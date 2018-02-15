module SiteHelper
	include CheckHelper

	def rfc_link_to(rfc)
		link_to "RFC #{rfc}", "https://tools.ietf.org/html/rfc#{rfc}", target: :_blank
	end

	def wikipedia_link_to(content, page)
		link_to content, "https://en.wikipedia.org/wiki/#{page}", target: :_blank
	end
end
