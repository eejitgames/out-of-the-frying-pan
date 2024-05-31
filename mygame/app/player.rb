class Player
  def initialize
      @x = 606
      @y = 155
      @w = 47 * 3
      @h = 51 * 3
      @path = Sprite.for(:player)
      @flip_horizontally = false
      @speed = 8
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

    curr_pos = { x: @x, y: @y }
    new_pos = case move
              when DIR_UP
                curr_pos.merge({ y: curr_pos.y + @speed })
              when DIR_DOWN
                curr_pos.merge({ y: curr_pos.y - @speed })
              when DIR_RIGHT
                @flip_horizontally = true
                curr_pos.merge({ x: curr_pos.x + @speed })
              when DIR_LEFT
                @flip_horizontally = false
                curr_pos.merge({ x: curr_pos.x - @speed })
              end
    @x, @y = new_pos.x, new_pos.y unless move.nil?
    nil
  end
end
