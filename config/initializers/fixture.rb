require 'ostruct'

class OpenStruct
	def self.deep(value)
		case value
			when Hash
				self.new value.collect { |k, v| [k, self.deep(v)] }.to_h
			when Enumerable
				value.collect { |v| self.deep v }
			else
				value
		end
	end
end
