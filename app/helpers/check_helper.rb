module CheckHelper
	private def __label(value, color, state=true)
		color = :default unless color
		color = "state-#{color}" if state
		"<span class=\"label label-#{color}\">#{value}</span>"
	end

	def label(value, color, state=true)
		__label(value, color, state).html_safe
	end

	def cell(value, color, state=true)
		"<td class=\"label-state-#{color}\">#{value}</td>".html_safe
	end

	def labels(level, states, state=true)
		states.each_pair.collect do |name, value|
			color = if value.nil?
						:default
					elsif ::CryptCheck::State.bad? level
						value ? :danger : :success
					else
						value ? :success : :danger
					end
			__label name, color, state
		end.join(' ').html_safe
	end

	def states(states)
		::CryptCheck::State.collect do |level|
			states[level].each_pair
					.select { |_, v| v == true }
					.collect { |name, _| __label name, level }
		end.flatten(1).join(' ').html_safe
	end

	def rank_color(rank)
		case rank
		when :'A+', :A
			:great
		when :'B+', :B
			:best
		when :'C+', :C
			:good
		when :D
			nil
		when :E
			:warning
		when :F
			:error
		else
			:critical
		end
	end

	def rank_label(rank)
		l = %i(V T).include? rank
		label rank, rank_color(rank), !l
	end

	def protocol_label(protocol)
		label protocol.to_sym, protocol.status
	end

	def protocol_labels(protocols)
		protocols.collect { |p| protocol_label p }.join("\n").html_safe
	end

	def key_label(key)
		return label('Aucune', :error) unless key
		label "#{key[:type].upcase} #{key[:size]} bits", key_color(key)
	end

	def key_labels(keys)
		return label('Aucune', :error) if keys.empty?
		keys.sort { |a, b| -1 * (a[:size] <=> b[:size]) }.collect { |k| key_label k }.join("\n").html_safe
	end

	def cipher_size_label(cipher)
		size = cipher.size if cipher.is_a? CryptCheck::Tls::Cipher
		label "#{size} bits", cipher_color(size)
	end

	def key_color(key)
		case key[:size]
		when nil then
			:default
		when 0...1024 then
			:error
		when 1024...2048 then
			:danger
		when 2048...4096 then
			:warning
		else
			:success
		end
	end

	def cipher_color(key)
		case key
		when nil then
			:default
		when 0...128 then
			:error
		when 112...128 then
			:danger
		when 128...256 then
			:success
		else
			:primary
		end
	end

	def cipher_name_label(cipher)
		status = cipher.status
		status = :success if status == :good
		label("&nbsp;", status) + "&nbsp;#{cipher.name}".html_safe
	end

	def cipher_labels(cipher)
		cipher.state.collect { |c, ls| ls.collect { |l| label l.upcase, c } }
				.flatten(1).join("\n").html_safe
	end

	def cipher_kex_type_cell(kex)
		color = case kex
				when :ecdh then
					nil
				when :dh then
					:warning
				when :rsa then
					:error
				else
					:critical
				end
		kex   ||= 'None'
		cell kex.to_s.upcase, color
	end

	def cipher_kex_size_cell(kex)
		color = key_color kex
		cell kex&.[](:size), color
	end

	def cipher_auth_type_cell(auth)
		color = case auth
				when :ecdsa, :rsa then
					nil
				else
					:critical
				end
		auth  ||= 'None'
		cell auth.to_s.upcase, color
	end

	def cipher_auth_size_cell(auth)
		color = key_color auth
		cell auth&.[](:size), color
	end

	def cipher_enc_type_cell(enc)
		color = case enc
				when :chacha20
					:success
				when nil, :rc4
					:critical
				end
		enc   ||= 'NONE'
		cell enc.to_s.upcase, color
	end

	def cipher_enc_block_size_cell(enc)
		color = case
				when enc == :stream
					nil
				when enc.nil?
					nil
				when enc <= 64
					:critical
				when enc < 128
					:error
				end
		cell enc, color
	end

	def cipher_enc_key_size_cell(enc)
		color = case
				when enc.nil?
					nil
				when enc < 128
					:critical
				end
		cell enc, color
	end

	def cipher_enc_mode_cell(enc)
		color = case enc
				when :gcm, :ccm, :aead
					:success
				end
		cell enc.to_s.upcase, color
	end

	def cipher_mac_type_cell(mac)
		color = case mac
				when :poly1305 then
					:success
				when :sha384, :sha256 then
					nil
				when :sha1 then
					:warning
				else
					:critical
				end
		cell mac.to_s.upcase, color
	end

	def cipher_mac_size_cell(mac)
		cell mac, nil
	end

	def cipher_pfs_cell(pfs)
		return cell 'PFS', nil if pfs
		cell 'No PFS', :error
	end
end
