include AttrGTK

def reset
  $gtk.args.state.defaults_set = nil
end

def tick args
  # we don't need to pass args, can drop args from general usage
  self.args = args
  # initialize the scene to scene 1
  state.current_scene ||= :tick_title_scene
  # capture the current scene to verify it didn't change through the duration of tick
  current_scene = state.current_scene
  # tick whichever scene is current
  send(current_scene)
  # make sure that the current_scene flag wasn't set mid tick
  if state.current_scene != current_scene
    raise "Scene was changed incorrectly. Set args.state.next_scene to change scenes."
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
  state.defaults_set = true
end

$gtk.reset
