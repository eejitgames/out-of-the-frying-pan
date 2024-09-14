class Game
  attr_gtk
  attr_accessor :customer_queue
  attr_accessor :customers

  def tick
    defaults
    input
    calc
    render

    outputs.debug.watch state
    outputs.watch "#{GTK.current_framerate} FPS"
  end

  def calc
    return if game_has_lost_focus?
    # check vector_x and vector_y separately, to see if they intersect with a table rect
    player_rect_x_dir = calc_player_rect(47, 2.5, state.player.x + @vector_x, state.player.y)
    player_rect_y_dir = calc_player_rect(47, 2.5, state.player.x, state.player.y + @vector_y)

    # use quad tree and find_intersect_rect_quad_tree to determine collision with player
    @vector_x = 0 if geometry.find_intersect_rect_quad_tree player_rect_x_dir, @tables_quad_tree
    @vector_y = 0 if geometry.find_intersect_rect_quad_tree player_rect_y_dir, @tables_quad_tree

    # update player x and y, also prevent player from going too far forward/back in the scene
    state.player.x = (state.player.x + @vector_x).cap_min_max(0, 1)
    state.player.y = (state.player.y + @vector_y).cap_min_max(0.02, 1)

    update_walking_customers

    @clock += 1
  end

  def defaults
    return if @defaults_set
    @screen_height ||= 720
    @screen_width ||= 1280
    @clock ||= 0
    state.player ||= {
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
    @entrance ||= {
      x: 0.74,
      y: 0.86
    }
    @customer_queue ||= {
      spot1: { x: 0.92, y: 0.68, occupied: nil }, # this is the front of the queue
      spot2: { x: 0.90, y: 0.70, occupied: nil },
      spot3: { x: 0.88, y: 0.72, occupied: nil },
      spot4: { x: 0.86, y: 0.74, occupied: nil },
      spot5: { x: 0.84, y: 0.76, occupied: nil },
      spot6: { x: 0.82, y: 0.78, occupied: nil },
      spot7: { x: 0.80, y: 0.80, occupied: nil },
      spot8: { x: 0.78, y: 0.82, occupied: nil }  # this is the back of the queue
    }
    @customers ||= {
      customer1: { x: 0.74, y: 0.86, speed: 0.0025, mode: :outside },  # starts at the entrance, moves to queue
      customer2: { x: -0.01, y: 0.86, speed: 0.0025, mode: :outside }, # starts off the left side, moves right
      customer3: { x: 1.01, y: 0.86, speed: -0.0025, mode: :outside }  # starts off the right side, move left
    }
    @next_customer_id = 4
    @tables_quad_tree ||= geometry.quad_tree_create table_rects
    @vector_x = 0
    @vector_y = 0
    @player_flip = true
    @max_customers = 50
    @add_customer_check = 0.98 # when lower, customers are added faster
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

    # customers
    @customers.each do |id, customer|
      render_items << {
        x: x_to_screen(customer.x),
        y: y_to_screen(customer.y),
        w: w_to_screen(47, 2.5, customer.y),
        h: h_to_screen(51, 2.5, customer.y),
        anchor_x: 0.5,
        anchor_y: 0.5,
        path: "sprites/player.png",
        flip_horizontally: customer.speed > 0
      }
    end
=begin
    # queue testing
    @customer_queue.each do |id, customer|
      render_items << {
        x: x_to_screen(customer.x),
        y: y_to_screen(customer.y),
        w: w_to_screen(47, 2.5, customer.y),
        h: h_to_screen(51, 2.5, customer.y),
        anchor_x: 0.5,
        anchor_y: 0.5,
        path: "sprites/player.png",
        flip_horizontally: true
      }
    end
=end
    # player
    render_items << {
      x: x_to_screen(state.player.x),
      y: y_to_screen(state.player.y),
      w: w_to_screen(47, 2.5, state.player.y),
      h: h_to_screen(51, 2.5, state.player.y),
      anchor_x: 0.5,
      anchor_y: 0.5,
      path: "sprites/player.png",
      flip_horizontally: @player_flip
    }
    # placeholder/doorway/entrance
    render_items << {
      x: x_to_screen(0.74),
      y: y_to_screen(0.8615),
      w: w_to_screen(100, 1.35, 0.86),
      h: h_to_screen(100, 1.5, 0.86),
      anchor_x: 0.5,
      anchor_y: 0.5,
      path: "sprites/entrance.png",
      flip_horizontally: true
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

  def customers_in_mode(mode, dir: nil)
    if dir.nil?
      @customers.values.select { |customer| customer[:mode] == mode }
    else
      if dir == :right
        @customers.values.select { |customer| customer[:mode] == mode && customer[:speed] >= 0}
      else # assumed left
        @customers.values.select { |customer| customer[:mode] == mode && customer[:speed] < 0}
      end
    end
  end

  def add_new_customer
    dir = rand > 0.5 ? :right : :left
    right_speed = rand * (0.0030 - 0.0020) + 0.0020 # min 0.0020, max 0.0030
    left_speed = right_speed * -1
    id = "customer#{@next_customer_id}".to_sym
    @next_customer_id += 1
    @customers[id] = { x: dir == :right ? -0.01 : 1.01, y: 0.86, speed: dir == :right ? right_speed : left_speed, mode: :outside }
  end

  def find_empty_spot_closest_to_the_front
    @customer_queue.each do |spot, details|
      return { spot: spot, details: details } if details[:occupied].nil?
    end
    nil # Return nil if no empty spot is found
  end

  def update_queueing_customers
    # return if there is no one in the queue
    return unless @customer_queue.any? { |_, spot| !spot[:occupied].nil? }
    # start at spot1, through to spot8 moving customers who are not standing where they should be
    # source and target coordinates are known, use easing to move to position in queue
    @customer_queue.each do |id, spot|
      next if spot.occupied.nil?
      if @customers[spot.occupied].x != spot.x || @customers[spot.occupied].y != spot.y
      # putz "#{spot.occupied} is not standing in the right place"
        sx = @entrance.x
        sy = @entrance.y
        tx = spot.x
        ty = spot.y
        progress = easing.ease(@customers[spot.occupied].start_time, @clock, 60, :smooth_stop_quad)
        calc_x = (sx + (tx - sx) * progress).cap_min_max(0, 1)
        calc_y = (sy + (ty - sy) * progress).cap_min_max(0, 1)
        @customers[spot.occupied].x = calc_x
        @customers[spot.occupied].y = calc_y
      end
    end

=begin
    outward_anchors.each_value do |anchor|
      sx = anchor.ship.x
      sy = anchor.ship.y
      tx = anchor.target.x
      ty = anchor.target.y
      progress = @args_easing.ease(anchor.start, @my_tick_count, anchor.duration, :smooth_stop_quad)
      calc_x = sx + (tx - sx) * progress
      calc_y = sy + (ty - sy) * progress
      anchor.state = :endpoint if progress >= 1
=end
  end

  def check_customers_at_entrance
    # return if there is no open spot in the queue
    spot_closest_to_the_front = find_empty_spot_closest_to_the_front
    return unless spot_closest_to_the_front
    in_doorway = @customers.find do |id, customer|
      customer[:mode] == :outside && customer[:x] >= @entrance.x - 0.002 && customer[:x] <= @entrance.x + 0.002
    end

    if in_doorway
      @customer_queue[spot_closest_to_the_front[:spot]].occupied = in_doorway[0]
      in_doorway[1].start_time = @clock
      in_doorway[1].mode = :queueing
    end
  end

  def update_walking_customers
    case @clock % 4
    when 1
      # tick 1, 5, 9, etc. update right moving customers
      customers_in_mode(:outside, dir: :right).each do |customer|
        # customer.x = @clock * customer.speed % 1
        customer.x += customer.speed
        customer.x = -0.01 if customer.x > 1.02
        customer.x = 1.01 if customer.x < -0.02
      end
    when 3
      # tick 3, 7, 11, etc. update left moving customers
      customers_in_mode(:outside, dir: :left).each do |customer|
        # customer.x = @clock * customer.speed % 1
        customer.x += customer.speed
        customer.x = -0.01 if customer.x > 1.02
        customer.x = 1.01 if customer.x < -0.02
      end
  else
      # check if any customers are at the entrance/join the queue, and update queue
      check_customers_at_entrance
      update_queueing_customers
      # also randomly add a new customer outside
      add_new_customer if rand > @add_customer_check && @customers.size < @max_customers
    end
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
