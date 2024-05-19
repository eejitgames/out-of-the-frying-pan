include AttrGTK

def reset
  $gtk.args.state.defaults_set = nil
end

def tick args
  # we don't need to pass args, can drop args from general usage
  self.args = args
  # set game defaults, if not already set
  set_defaults if state.defaults_set.nil?
  # capture the current scene to verify it didn't change through the duration of tick
  current_scene = state.current_scene
  # tick whichever scene is current
  send(current_scene)
  # make sure that the current_scene flag wasn't set mid tick
  if state.current_scene != current_scene
    raise "Scene was changed incorrectly. Set state.next_scene to change scenes."
  end

  # if next scene was set/requested, then transition the current scene to the next scene
  if state.next_scene
    state.current_scene = state.next_scene
    state.next_scene = nil
  end
end

def tick_title_scene
  outputs.labels << { x: 640, y: 360, text: "Title Scene (click to go to game)", alignment_enum: 1 }

  if inputs.mouse.click
    state.next_scene = :tick_game_scene
  end
end

def tick_game_scene
  outputs.labels << { x: 640, y: 360, text: "Game Scene (click to go to game over)", alignment_enum: 1 }
  outputs.sprites << { x: state.logo_rect.x, y: state.logo_rect.y, w: state.logo_rect.w, h: state.logo_rect.h, path: 'dragonruby.png' }

  if inputs.keyboard.left
    state.logo_rect.x -= 10
  elsif inputs.keyboard.right
    state.logo_rect.x += 10
  end

  if state.logo_rect.x > 1280
    state.logo_rect.x = 0
  elsif state.logo_rect.x < 0
    state.logo_rect.x = 1280
  end

  if inputs.mouse.click
    state.next_scene = :tick_game_over_scene
  end
end

def tick_game_over_scene
  outputs.labels << { x: 640, y: 360, text: "Game Over Scene (click to go to title)", alignment_enum: 1 }

  if inputs.mouse.click
    state.next_scene = :tick_title_scene
  end
end

def set_defaults
  state.current_scene = :tick_title_scene
  state.logo_rect = { x: 576, y: 0, w: 128, h: 101 }
  state.defaults_set = true
end

$gtk.reset
