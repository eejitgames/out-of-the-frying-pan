include AttrGTK

module ToggleExtension
  def toggle
    putz "the console was toggled"
    super
  end
end

GTK::Console.prepend ToggleExtension

def boot args
  args.state = nil
end

def reset args
  state.game = nil
end

def tick args
  args.state ||= {}
  self.args = args
  state.game ||= {
    current_scene: :title_scene,
    clock: 0
  }

  current_scene = state.game.current_scene
  outputs.debug.watch state.game

  send(current_scene)

  if state.game.next_scene
    state.game.current_scene = state.game.next_scene
    state.game.next_scene = nil
  end
end

def title_scene
  outputs.labels << { x: 640, y: 40, text: "Title Scene (click to go to game)", alignment_enum: 1 }

  return if game_has_lost_focus?

  if inputs.mouse.click
    state.game.next_scene = :game_scene
  end
end

def game_scene

=begin
    input
    calc
    render
=end

  render_array = []
  render_array << { x: 0, y: 0, w: 1280, h: 720, path: "sprites/fuds.png" }
  render_array << { x: 640, y: 40, text: "Game Scene (click to go to game over)", alignment_enum: 1 }
  render_array << { x: 1195, y: 640, w: 128 / 2, h: 101 / 2, path: 'dragonruby.png', angle: state.game.clock }
  outputs.primitives << render_array

  return if game_has_lost_focus?

  state.game.clock += 1

  if inputs.mouse.click
    state.game.next_scene = :game_over_scene
  end
end

def game_over_scene
  outputs.labels << { x: 640, y: 40, text: "Game Over Scene (click to go to title)", alignment_enum: 1 }

  return if game_has_lost_focus?

  if inputs.mouse.click
    state.game.next_scene = :title_scene
  end
end

def game_has_lost_focus?
  return true if Kernel.tick_count < 1

  current_focus = !inputs.keyboard.has_focus

  if current_focus != state.game.lost_focus
    if current_focus
      # puts "lost focus"
      # audio[:music].paused = true
    else
      # puts "gained focus"
      # audio[:music].paused = false
    end
  end
  state.game.lost_focus = current_focus
end

$gtk.reset
$gtk.disable_framerate_warning!
