class Player
  attr_accessor :x, :y, :right_hand_plates, :left_hand_plates, :plate_balance

  def initialize
      @x = 606
      @y = 155
      @w = 47 * 2
      @h = 51 * 2
      @path = Sprite.for(:player)
      @flip_horizontally = false
      @velocity = { x: 0, y: 0 }
      @velocity_min = -20
      @velocity_max = 20
      @acceleration = 700
      @friction = 5
      @mass = 20
      @score = 0
      @right_hand_plates = 0
      @left_hand_plates = 0
      @plate_mass = 0
      @plate_balance = 0
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

    if add_plate_right_hand?(args)
      @right_hand_plates += 1
      @mass += @plate_mass
    end

    if add_plate_left_hand?(args)
      @left_hand_plates += 1
      @mass += @plate_mass
    end

    @plate_balance = (@right_hand_plates - @left_hand_plates) / 2

    case move
      when DIR_RIGHT
        @flip_horizontally = true
        @velocity.x += @acceleration / @mass
      when DIR_LEFT
        @flip_horizontally = false
        @velocity.x -= @acceleration / @mass
    end

    @velocity.x *= @friction / @mass
    @velocity.x += @plate_balance
    @velocity.x = @velocity.x.cap_min_max(@velocity_min, @velocity_max)
    @x += @velocity.x
    nil
  end
end
