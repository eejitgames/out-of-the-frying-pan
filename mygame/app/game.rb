class Game
  attr_gtk

  def tick
    defaults
    input
    calc
    render

    outputs.debug.watch state
  end

  def calc
    return if game_has_lost_focus?

    # update player x and y
    state.player.x = (state.player.x + @player_left + @player_right).cap_min_max(0, 1)
    state.player.y = (state.player.y + @player_up + @player_down).cap_min_max(0, 1)

    state.clock += 1
  end

  def defaults
    return if @defaults_set
    puts_dev "setting defaults"
    @screen_height = 720
    @screen_width = 1280
    state.clock ||= 0
    state.player ||= {
      x: 0.5,
      y: 0.22,
      speed: 0.005
    }
    @defaults_set = :true
  end

  def input
    @player_up = 0
    @player_down = 0
    @player_left = 0
    @player_right = 0

    if args.inputs.up
      @player_up = state.player.speed
    end
    if args.inputs.down
      @player_down = -state.player.speed
    end
    if args.inputs.left
      @player_left = -state.player.speed
    end
    if args.inputs.right
      @player_right = state.player.speed
    end
  end

  def render
    outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, path: "sprites/fuds.png" }
    outputs.primitives << {
      x: state.player.x * @screen_width,
      y: state.player.y * @screen_height,
      w: 47,
      h: 51,
      path: "sprites/player.png"
    }
  end

  def game_has_lost_focus?
    return true unless Kernel.tick_count > 0
    focus = !inputs.keyboard.has_focus

    if focus != state.lost_focus
      if focus
        puts_dev "lost focus"
        # audio[:music].paused = true
      else
        puts_dev "gained focus"
        # audio[:music].paused = false
      end
    end
    state.lost_focus = focus
  end

  def puts_dev(msg)
    puts msg unless gtk.production
  end
end
