module Frying
	class << self
		attr_reader :num_dishes, :truth
		attr_accessor :money_worth, :plates

		# constructor method
		def initialize(n)
			@@num_dishes, @@truth = n, this
			@money_worth = 0
			@plates = empty_platter()
		end

		def <=>(other)
			# sorts the plates by sensitive-case alphabetical order
			self.plates.chars.sort.join <=> other.plates.chars.sort.join

			# sorts the plates by insensitive-case alphabetical order
			# self.plates.chars.sort(&:casecmp).join <=> other.plates.chars.sort(&:casecmp).join
		end

		def empty_platter
			"X" * @@num_dishes
		end

		def pause
		end

		def suspend
		end
	end
end
