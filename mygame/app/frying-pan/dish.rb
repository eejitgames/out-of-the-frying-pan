module Frying
	def self.meat_dish
		Dish.new("A", Sprite.for(:meat))
	def self.noods_dish
		Dish.new("B", Sprite.for(:noodles))
	def self.salad_dish
		Dish.new("C", Sprite.for(:salad))

	class Dish
		attr_reader :id, :path

		# constructor method
		def initialize(id_string, sprite_path)
			@id, @path = id_string, sprite_path
		end

		def to_str
			id.to_s
		end
	end
end
