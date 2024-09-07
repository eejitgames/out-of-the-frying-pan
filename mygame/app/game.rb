class Game
  attr_gtk

  def tick
    defaults
    # input
    calc
    # render

    outputs.debug.watch state
  end

  def calc
    return if game_has_lost_focus?
    state.clock += 1
  end

  def defaults
    return if @defaults_set
    puts_dev "setting defaults"
    state.clock ||= 0
    @defaults_set = :true
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
