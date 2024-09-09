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
    # check vector_x and vector_y separately, to see if they intersect with a table rect
    player_rect_x_dir = calc_player_rect(47, 2.5, @player.x + @vector_x, @player.y)
    player_rect_y_dir = calc_player_rect(47, 2.5, @player.x, @player.y + @vector_y)

    # use quad tree and find_intersect_rect_quad_tree to determine collision with player
    @vector_x = 0 if geometry.find_intersect_rect_quad_tree player_rect_x_dir, @tables_quad_tree
    @vector_y = 0 if geometry.find_intersect_rect_quad_tree player_rect_y_dir, @tables_quad_tree

    # update player x and y, also prevent player from going too far forward/back in the scene
    @player.x = (@player.x + @vector_x).cap_min_max(0, 1)
    @player.y = (@player.y + @vector_y).cap_min_max(0.02, 0.39)

    @clock += 1
  end

  def defaults
    return if @defaults_set
    @screen_height ||= 720
    @screen_width ||= 1280
    @clock ||= 0
    @player ||= {
      x: 0.48,
      y: 0.22,
      speed: 0.005,
    }

    @tables ||= {
      table1: { x: 0.08, y: 0.32 },
      table2: { x: 0.29, y: 0.32 },
      table3: { x: 0.69, y: 0.32 },
      table4: { x: 0.91, y: 0.32 },
      table5: { x: 0.10, y: 0.1  },
      table6: { x: 0.34, y: 0.1  },
      table7: { x: 0.63, y: 0.1  },
      table8: { x: 0.87, y: 0.1  }
    }

    table_rects = @tables.map do |id, table|
      table_width = w_to_screen(139, 1.7, table.y)
      table_height = h_to_screen(62, 1.7, table.y)
        {
          x: x_to_screen(table.x) - table_width/2,
          y: y_to_screen(table.y) - table_height/8,
          w: table_width,
          h: table_height/1.5
        }
      end

    @tables_quad_tree ||= geometry.quad_tree_create table_rects
    @vector_x = 0
    @vector_y = 0
    @player_flip = true
    @defaults_set = :true
  end

  def input
    return if game_has_lost_focus?
    vector = inputs.directional_vector
    if vector
      @vector_x = vector.x * @player.speed
      @vector_y = vector.y * @player.speed
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

    # tables
    @tables.each do |id, table|
      render_items << {
        x: x_to_screen(table.x),
        y: y_to_screen(table.y),
        w: w_to_screen(139, 1.7, table.y),
        h: h_to_screen(62, 1.7, table.y),
        anchor_x: 0.5,
        anchor_y: 0.5,
        path: "sprites/table.png",
        flip_horizontally: table.x * @screen_width < @screen_width / 2,
      }
    end

    # player
    render_items << {
      x: x_to_screen(@player.x),
      y: y_to_screen(@player.y),
      w: w_to_screen(47, 2.5, @player.y),
      h: h_to_screen(51, 2.5, @player.y),
      anchor_x: 0.5,
      anchor_y: 0.5,
      path: "sprites/player.png",
      flip_horizontally: @player_flip
    }

    outputs.primitives << render_items.sort_by { |item| item.y }.reverse
  end

  def x_to_screen(x)
    x * @screen_width
  end

  def y_to_screen(y)
    y * @screen_height
  end

  def w_to_screen(w, scale, y)
    w * scale * (1 - y)
  end

  def h_to_screen(h, scale, y)
    h * scale * (1 - y)
  end

  def calc_player_width_for_hitbox_with_tables(w, scale, y)
    if y > 0.23
      w_to_screen(w, scale, 0.31)
    else
      w_to_screen(w, scale, 0.12)
    end
  end

  def calc_player_rect(w, scale, x, y)
    player_width = calc_player_width_for_hitbox_with_tables(w, scale, y)
    { x: x_to_screen(x) - player_width/2, y: y_to_screen(y), w: player_width, h: 0 }
  end

  def game_has_lost_focus?
    return true unless Kernel.tick_count > 0
    focus = !inputs.keyboard.has_focus

    if focus != state.lost_focus
      if focus
        # putz "lost focus"
        # audio[:music].paused = true
      else
        # putz "gained focus"
        # audio[:music].paused = false
      end
    end
    state.lost_focus = focus
  end
end

GTK.reset
