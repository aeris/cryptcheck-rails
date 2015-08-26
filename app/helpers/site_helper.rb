module SiteHelper
	def rank_color(rank)
		case rank
			when 'A+' then :primary
			when 'A' then :success
			when 'B' then :default
			when 'C', 'D' then :warning
			when 'E', 'F' then :danger
			else :error
		end
	end

	def rank_label(rank)
		"<span class=\"label label-#{rank_color rank}\">#{rank}</span>".html_safe
	end

	def progress_color(percentage)
		case percentage
			when 0...20 then :error
			when 20...40 then :danger
			when 40...60 then :warning
			when 60...80 then :default
			when 80...90 then :success
			else :primary
		end
	end

	def score_progress(score)
		%Q(<div class="progress">
			 <div class="progress-bar progress-bar-striped progress-bar-#{progress_color score}"
						style="width: #{score}%">
				#{score} / 100
			</div>
		</div>).html_safe
	end

	def protocol_label(protocol)
		color = case protocol.to_s
			when 'TLSv1_2' then :success
			when 'SSLv3', 'SSLv2' then :danger
			else :default
		end
		"<span class=\"label label-#{color}\">#{protocol}</span>".html_safe
	end

	def protocol_labels(protocols)
		protocols.collect { |p| protocol_label p }.join("\n").html_safe
	end

	def key_label(key)
		return '<span class="label label-error">Aucune</span>'.html_safe unless key
		"<span class=\"label label-#{color_key key}\">#{key.type.upcase} #{key[:size]} bits</span>".html_safe
	end

	def key_labels(keys)
		return '<span class="label label-error">Aucune</span>'.html_safe if keys.empty?
		keys.sort { |a, b| -1 * (a.rsa_size <=> b.rsa_size)} .collect { |k| key_label k }.join("\n").html_safe
	end

	def cipher_size_label(cipher)
		size = cipher.kind_of?(CryptCheck::Tls::Cipher) ? cipher.size : cipher['size']
		"<span class=\"label label-#{cipher_color size} %>\">#{size} bits</span>".html_safe
	end

	def color_key(key)
		case key.rsa_size
			when 0...1024 then :error
			when 1024...2048 then :danger
			when 2048...4096 then :warning
			else :success
		end
	end

	def cipher_color(key)
		case key
			when 0...112 then :danger
			when 112...128 then :warning
			when 128...256 then :success
			else :primary
		end
	end

	def cipher_name_label(cipher, state)
		color = case
			when !state[:danger].empty? then :danger
			when !state[:warning].empty? then :warning
			when !state[:success].empty? then :success
			else :default
		end
		color = :primary if color == :success and cipher.size >= 256
		"<span class=\"label label-#{color} %>\">#{cipher.name}</span>".html_safe
	end

	def cipher_labels(cipher)
		case cipher
			when Hashie::Mash
				{ success: %i(pfs),
				  warning: %i(des3 sha1),
				  danger: %i(md5 psk srp anonymous null export des rc2 rc4)
				}.collect do |c, ts|
					ts.select { |t| CryptCheck::Tls::Cipher.send "#{t}?", cipher.name }.collect { |t| [c, t] }
				end
			when Hash
				cipher.collect { |c, ts| ts.collect { |t| [c, t] } }
		end
		.flatten(1)
		.collect { |c, t| "<span class=\"label label-#{c}\">#{t.upcase}</span>" }
		.join("\n").html_safe
	end
end
