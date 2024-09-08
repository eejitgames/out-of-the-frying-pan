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
    # update player x and y, prevent player from going too far back in the scene
    state.player.x = (state.player.x + @vector_x).cap_min_max(0, 1)
    state.player.y = (state.player.y + @vector_y).cap_min_max(0.03, 0.31)

    state.clock += 1
  end

  def defaults
    return if @defaults_set
    puts_dev "setting defaults"
    @screen_height = 720
    @screen_width = 1280
    state.clock ||= 0
    state.player ||= {
      x: 0.48,
      y: 0.22,
      speed: 0.005
    }
    state.tables ||= {
      table1: { x: 0.08, y: 0.32 },
      table2: { x: 0.27, y: 0.32 },
      table3: { x: 0.715, y: 0.32 },
      table4: { x: 0.90, y: 0.32 },
      table5: { x: 0.10, y: 0.1  },
      table6: { x: 0.34, y: 0.1  },
      table7: { x: 0.63, y: 0.1  },
      table8: { x: 0.86, y: 0.1  }
    }
    @vector_x = 0
    @vector_y = 0
    @player_flip = true
    @defaults_set = :true
  end

  def input
    return if game_has_lost_focus?
    vector = inputs.directional_vector
    if vector
      @vector_x = vector.x * state.player.speed
      @vector_y = vector.y * state.player.speed
      @player_flip = true if @vector_x > 0
      @player_flip = false if @vector_x < 0
    else
      @vector_x = 0
      @vector_y = 0
    end
  end

  def render
    outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, path: "sprites/fuds.png" }

    render_items = []
    state.tables.each do |id, table|
      render_items << {
        x: table.x * @screen_width,
        y: table.y * @screen_height,
        w: 139 * 1.7 * (1 - table.y),
        h: 62 * 1.7 * (1 - table.y),
        anchor_x: 0.5,
        anchor_y: 0.5,
        path: "sprites/table.png",
        flip_horizontally: table.x * @screen_width < @screen_width / 2,
      }
    end
    render_items << {
      x: state.player.x * @screen_width,
      y: state.player.y * @screen_height,
      w: 47 * 2 * (1 - state.player.y),
      h: 51 * 2 * (1 - state.player.y),
      anchor_x: 0.5,
      anchor_y: 0.5,
      path: "sprites/player.png",
      flip_horizontally: @player_flip
    }
    outputs.primitives << render_items.sort_by { |hash| hash.y }.reverse
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

GTK.reset
