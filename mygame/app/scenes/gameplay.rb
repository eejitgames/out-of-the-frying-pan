module Scene
  def self.tick_gameplay(args)
    GameplayScene.tick(args)
  end

  module GameplayScene
    class << self
      # This is your main entrypoint into the actual fun part of your game!
      def tick(args)
        labels = []
        sprites = []

        # focus tracking
        if !args.state.has_focus && args.inputs.keyboard.has_focus
          args.state.has_focus = true
        elsif args.state.has_focus && !args.inputs.keyboard.has_focus
          args.state.has_focus = false
        end

        # auto-pause & input-based pause
        if !args.state.has_focus || pause_down?(args)
          return pause(args)
        end

        tick_pause_button(args, sprites) if mobile?        
        draw_bg_sprite(args, { path: Sprite.for(:background) })

        args.state.gameplay.waiter ||= Player.new

        args.state.gameplay.waiter.tick(args)

        labels << { x: args.state.gameplay.waiter.x - 10,
                    y: args.state.gameplay.waiter.y + 100,
                    text: args.state.gameplay.waiter.left_hand_plates,
                    size_enum: 20
                  }
        labels << { x: args.state.gameplay.waiter.x + 74,
                    y: args.state.gameplay.waiter.y + 100,
                    text: args.state.gameplay.waiter.right_hand_plates,
                    size_enum: 20
                  }
        sprites << args.state.gameplay.waiter.sprite_as_hash

        args.outputs.labels << labels
        args.outputs.sprites << sprites
      end

      def pause(args)
        play_sfx(args, :select)
        return Scene.switch(args, :paused, reset: true)
      end

      def tick_pause_button(args, sprites)
        pause_button = {
          x: 72.from_right,
          y: 72.from_top,
          w: 52,
          h: 52,
          path: Sprite.for(:pause),
        }
        pause_rect = pause_button.dup
        pause_padding = 12
        pause_rect.x -= pause_padding
        pause_rect.y -= pause_padding
        pause_rect.w += pause_padding * 2
        pause_rect.h += pause_padding * 2
        if args.inputs.mouse.down && args.inputs.mouse.inside_rect?(pause_rect)
          return pause(args)
        end
        sprites << pause_button
      end
    end
  end
end
