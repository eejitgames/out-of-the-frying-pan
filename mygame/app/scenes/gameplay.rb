module Scene
  def self.tick_gameplay(args)
    GameplayScene.tick(args)
  end

  module GameplayScene
    class << self
      # This is your main entrypoint into the actual fun part of your game!
      def tick(args)
#region Initialize
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
#endregion

        draw_bg_sprite(args, { path: Sprite.for(:background) })

        args.state.gameplay.waiter ||= Frying::Player.new

        args.state.gameplay.waiter.tick(args)

        args.state.gameplay.debug_platters ||= true

        if args.state.gameplay.debug_platters
          if args.state.gameplay.debug_sample_platter.nil?
            debug_add_platters(args, args.state.gameplay.waiter)
            args.state.gameplay.debug_sample_platter ||= true
          end
          debug_draw_text_platters(args, args.state.gameplay.waiter)
        end

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

      private

      def debug_draw_text_platters(args, waiter)
        def inner(args, platter, xpos, ypos)
          platter.chars.map.with_index { |ch, ind| { x: xpos, y: ypos + 45*ind, text: ch, size_enum: 20 }}
        end
        args.outputs.labels << inner(args, waiter.left_plates, waiter.x - 10, waiter.y + 100)
        args.outputs.labels << inner(args, waiter.middle_plates, waiter.x + 40, waiter.y + 120)
        args.outputs.labels << inner(args, waiter.right_plates, waiter.x + 74, waiter.y + 100)
        args
      end

      def debug_add_platters(args, waiter)
        waiter.add(Frying.meat_dish, 1)
        waiter.add(Frying.noods_dish, 1)
        waiter.add("B", 1)
        waiter.add("F", 2)
        waiter.add(Frying.salad_dish, 3)
        waiter.add("B", 3)
        waiter.add("C", 3)
        waiter.swap(nil, 2, 1)
        waiter.swap(nil, 3, 2)
      end
    end
  end
end
