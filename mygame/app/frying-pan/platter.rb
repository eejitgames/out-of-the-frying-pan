module Frying
	# Provides a symbolic reference for subclasses to reference to synchronize the number of dishes required.
	# By using @@truth.num_dishes, the Waiter and Table will have identical number of dishes that are used.
	#
	# Additionally, it specifies a unifying set of fields for money, helper methods, and comparison.
	# This will help us verify that the Waiter has the dish requested at each Table.
	class Platter
		attr_reader :num_dishes, :truth
		attr_accessor :money_worth, :plates

		# constructor method
		def initialize(n)
			@@num_dishes, @@truth = n, self
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
