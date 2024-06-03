module Scene
  def self.tick_cook(args)
    CookingScene.tick(args)
  end

  module CookingScene
    class << self
      # what's displayed when your game starts
      def tick(args)
        labels = []
        sprites = []

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
    end
  end
end
