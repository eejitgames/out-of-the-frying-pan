module Player
  class << self
    def create
      {
        x: 640,
        y: 360,
        w: 47,
        h: 51,
        path: Sprite.for(:player),
        flip_horizontally: false
      }
    end
    
    def tick(args, player)
      move = nil
      move = DIR_UP if up?(args)
      move = DIR_DOWN if down?(args)
      move = DIR_RIGHT if right?(args)
      move = DIR_LEFT if left?(args)
      
      curr_pos = { x: player.x, y: player.y }
      new_pos = case move
                when DIR_UP
                  curr_pos.merge({ y: curr_pos.y + 1 })
                when DIR_DOWN
                  curr_pos.merge({ y: curr_pos.y - 1 })
                when DIR_RIGHT
                  player.flip_horizontally = true
                  curr_pos.merge({ x: curr_pos.x + 1 })
                when DIR_LEFT
                  player.flip_horizontally = false
                  curr_pos.merge({ x: curr_pos.x - 1 })
                end
      player.merge!(new_pos) unless move.nil?
    end
  end
end
