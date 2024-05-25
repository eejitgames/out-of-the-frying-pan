module Frying
	class << self < platter
		# static value
		@@total_customers = 0

		@empty = true
		@wait_time = 0
		@infinite_patience = (2**(0.size * 8 -2) -1)
		@patience = 1000

		# constructor method
		def initialize()
			@n_dishes = :truth.num_dishes
			@money_worth = 0
			@plates = empty_platter()
		end

		def tick(args)
			@wait_time -= 1
			if @wait_time <= 0
				timeout()
				@wait_time = @patience
			end
		end

		def suspend
		end

		private

		def timeout(args)
			if @empty
				populate()
				@empty = false
			else
				anger()
				@empty = true
			end
		end

		def populate(args)
			random_platter()
		end

		def anger(args)
			empty_platter()
		end
	end
end
