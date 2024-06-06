module Frying
	class Waiter < Platter
		attr_reader :left_plates, :middle_plates, :right_plates

		# constructor method
		def initialize()
			@n_dishes = @@num_dishes
			@money_worth = 0
			@plates = empty_platter()
			@left_plates = "X"
			@middle_plates = "X"
			@right_plates = "X"
		end

		def add(args, to)
			puts "GO"
			puts @n_dishes
			puts "1"
			puts @@truth
			puts "2"
			puts @@truth.num_dishes
			puts "STOP"
			if to == 1
				if @left_plates == "X"
					@left_plates = ""
				end
				@left_plates = @left_plates.concat(args)
			elsif to == 3
				if @right_plates == "X"
					@right_plates = ""
				end
				@right_plates = @right_plates.concat(args)
			elsif to == 2
				if @n_dishes == 2
					add(args, 3)
				else
					if @middle_plates == "X"
						@middle_plates = ""
					end
					@middle_plates = @middle_plates.concat(args)
				end
			else
				raise RangeError.new("Plate being added to non-existent hand")
			end

			update_plates
			nil
		end

		def swap(args, from, to)
			if from <= 0 || from > 3 || to <= 0 || to > 3
				raise RangeError.new("Plate being swapped to non-existent hand")
			end
			if @n_dishes == 2 && from == 2
				from = 3
			end
			if @n_dishes == 2 && to == 2
				to = 3
			end
			if to == from
				return false
			end

			winrar = ""
			if from == 1 && ! @left_plates.empty? && @left_plates != "X"
				winrar = @left_plates[-1]
				@left_plates = @left_plates.chop
			elsif from == 2 && ! @middle_plates.empty? && @middle_plates != "X"
				winrar = @middle_plates[-1]
				@middle_plates = @middle_plates.chop
			elsif from == 3 && ! @right_plates.empty? && @right_plates != "X"
				winrar = @right_plates[-1]
				@right_plates = @right_plates.chop
			end

			if winrar.empty?
				return false
			end

			if to == 1
				@left_plates = @left_plates.concat(winrar)
			elsif to == 2
				@middle_plates = @middle_plates.concat(winrar)
			elsif to == 3
				@right_plates = @right_plates.concat(winrar)
			end

			update_plates
			true
		end

		def present(args, other_table)
			# if other_table.plates == @plates do?()

			@left_plates = @left_plates.chop
			@middle_plates = @middle_plates.chop
			@right_plates = @right_plates.chop
			update_plates
			other_table
		end

		private

		def update_plates
			if @left_plates.empty?
				@left_plates = "X"
			end
			if @middle_plates.empty?
				@middle_plates = "X"
			end
			if @right_plates.empty?
				@right_plates = "X"
			end
			if @n_dishes == 2
				@plates = "".concat(@left_plates[-1])
				@plates = @plates.concat(@right_plates[-1])
			else
				@plates = "".concat(@left_plates[-1])
				@plates = @plates.concat(@middle_plates[-1])
				@plates = @plates.concat(@right_plates[-1])
			end
			nil
		end
	end
end
