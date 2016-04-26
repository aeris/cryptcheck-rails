module CheckHelper
	def label(value, color)
		"<span class=\"label label-#{color} %>\">#{value}</span>".html_safe
	end

	def cell(value, color)
		"<td class=\"#{color}\">#{value}</td>".html_safe
	end

	def rank_color(rank)
		case rank
			when 'A+' then
				:primary
			when 'A' then
				:success
			when 'B' then
				:default
			when 'C', 'D' then
				:warning
			when 'E', 'F' then
				:danger
			else
				:error
		end
	end

	def rank_label(rank)
		label rank, rank_color(rank)
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
					when 'SSLv3', 'SSLv2' then :error
					else :default
				end
		label protocol, color
	end

	def protocol_labels(protocols)
		protocols.collect { |p| protocol_label p }.join("\n").html_safe
	end

	def key_label(key)
		return label('Aucune', :error) unless key
		label "#{key.type.upcase} #{key[:size]} bits", key_color(key)
	end

	def key_labels(keys)
		return label('Aucune', :error) if keys.empty?
		keys.sort { |a, b| -1 * (a.rsa_size <=> b.rsa_size) }.collect { |k| key_label k }.join("\n").html_safe
	end

	def cipher_size_label(cipher)
		size = cipher.size if cipher.is_a? CryptCheck::Tls::Cipher
		label "#{size} bits", cipher_color(size)
	end

	def key_color(key)
		case key&.rsa_size
			when nil then :default
			when 0...1024 then :error
			when 1024...2048 then :danger
			when 2048...4096 then :warning
			else :success
		end
	end

	def cipher_color(key)
		case key
			when nil then :default
			when 0...112 then :error
			when 112...128 then :danger
			when 128...256 then :success
			else :primary
		end
	end

	def cipher_name_label(cipher)
		state = cipher.state
		color = case
					when !state[:error].empty? then :error
					when !state[:danger].empty? then :danger
					when !state[:warning].empty? then :warning
					when !state[:success].empty? then :success
					else :default
				end
		color = :primary if color == :success and cipher.size >= 256
		label("&nbsp;", color) + "&nbsp;#{cipher.name}".html_safe
	end

	def cipher_labels(cipher)
		cipher.state.collect { |c, ls| ls.collect { |l| label l.upcase, c } }
		.flatten(1).join("\n").html_safe
	end

	def cipher_kex_type_cell(kex)
		color = case kex
					when :ecdh then :primary
					when :dh then :success
					when :rsa then :warning
					else :error
				end
		kex ||= 'None'
		cell kex.to_s.upcase, color
	end

	def cipher_kex_size_cell(kex)
		color = key_color kex
		cell kex&.[](:size), color
	end

	def cipher_auth_type_cell(auth)
		color = case auth
					when :ecdsa then :primary
					when :rsa then :default
					else :error
				end
		auth ||= 'None'
		cell auth.to_s.upcase, color
	end

	def cipher_auth_size_cell(auth)
		color = key_color auth
		cell auth&.[](:size), color
	end

	def cipher_enc_type_cell(enc)
		color = case enc
					when :chacha20 then :primary
					when :aes then :success
					when :camellia, :seed, :idea then :default
					when :'3des' then :danger
					else :error
				end
		enc ||= 'NONE'
		cell enc.to_s.upcase, color
	end

	def cipher_enc_key_size_cell(enc)
		enc ||= 0
		color = cipher_color enc
		cell enc, color
	end

	def cipher_enc_block_size_cell(enc)
		return cell '', :default unless enc
		color = cipher_color enc
		cell enc, color
	end

	def cipher_enc_mode_cell(enc)
		color = case enc
					when :gcm, :ccm then :primary
					when :cbc then :warning
				end
		enc ||= ''
		cell enc.to_s.upcase, color
	end

	def cipher_mac_type_cell(mac)
		color = case mac
					when :poly1305 then :primary
					when :sha384, :sha256 then :success
					when :sha1 then :default
					when :md5 then :error
				end
		cell mac.to_s.upcase, color
	end

	def cipher_mac_size_cell(mac)
		cell mac, nil
	end

	def cipher_pfs_cell(pfs)
		return cell 'PFS', :success if pfs
		cell 'No PFS', :warning
	end
end
