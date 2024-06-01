class Player
  def initialize
      @x = 606
      @y = 155
      @w = 47 * 3
      @h = 51 * 3
      @path = Sprite.for(:player)
      @flip_horizontally = false
      @velocity = { x: 0, y: 0 }
      @velocity_min = -25
      @velocity_max = 25
      @acceleration = 2
      @friction = 1
      @score = 0
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
    move = nil
    move = DIR_UP if up?(args)
    move = DIR_DOWN if down?(args)
    move = DIR_RIGHT if right?(args)
    move = DIR_LEFT if left?(args)

    case move
      when DIR_UP
        @velocity.y += @acceleration
      when DIR_DOWN
        @velocity.y -= @acceleration
      when DIR_RIGHT
        @flip_horizontally = true
        @velocity.x += @acceleration
      when DIR_LEFT
        @flip_horizontally = false
        @velocity.x -= @acceleration
    end

    if @velocity.x > 0
      @velocity.x -= @friction
      @velocity.x = 0 if @velocity.x < 0
    elsif @velocity.x < 0
      @velocity.x += @friction
      @velocity.x = 0 if @velocity.x > 0
    end

    @velocity.x = @velocity.x.cap_min_max(@velocity_min, @velocity_max)
    @x += @velocity.x
    nil
  end
end
