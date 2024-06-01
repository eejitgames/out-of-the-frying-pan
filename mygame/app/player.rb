class Player
  attr_accessor :x, :y, :right_hand_plates, :left_hand_plates

  def initialize
      @x = 606
      @y = 155
      @w = 47 * 3
      @h = 51 * 3
      @path = Sprite.for(:player)
      @flip_horizontally = false
      @velocity = { x: 0, y: 0 }
      @velocity_min = -20
      @velocity_max = 20
      @acceleration = 800
      @friction = 5
      @mass = 20
      @score = 0
      @right_hand_plates = 0
      @left_hand_plates = 0
  end

  def sprite_as_hash
    {
      x: @x,
      y: @y,
      w: @w,
      h: @h,
      path: @path,
      flip_horizontally: @flip_horizontally,
      speed: @speed
    }
  end

  def tick(args)
    move = DIR_RIGHT if right?(args)
    move = DIR_LEFT if left?(args)

    @right_hand_plates += 1 if add_plate_right_hand?(args)
    @left_hand_plates += 1 if add_plate_left_hand?(args)
    plate_balance = @right_hand_plates - @left_hand_plates

    case move
      when DIR_RIGHT
        @flip_horizontally = true
        @velocity.x += @acceleration / @mass
        puts "balance: #{plate_balance}"
      when DIR_LEFT
        @flip_horizontally = false
        @velocity.x -= @acceleration / @mass
        puts "balance: #{plate_balance}"
    end

    @velocity.x *= @friction / @mass
    @velocity.x = @velocity.x.cap_min_max(@velocity_min, @velocity_max)
    @x += @velocity.x
    nil
  end
end
