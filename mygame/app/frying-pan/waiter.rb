module Frying
	class << self < platter
		attr_reader :n_dishes

		# constructor method
		def initialize()
			@n_dishes = :truth.num_dishes
			@money_worth = 0
			@plates = empty_platter()
		end

		def swap(args, n, val)
		end

		def present(args, other_table)
		end
	end
end
