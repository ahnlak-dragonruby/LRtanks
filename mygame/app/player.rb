# player.rb - part of LRTank
#
# Defines the player; knows how to render her and handles all actions

class Player

  # Attributes
  attr_accessor :player_x, :player_y, :angle


  # Some useful constants
  PLAYER_WIDTH=9
  PLAYER_HEIGHT=9
  PLAYER_OFFSET_X=4
  PLAYER_OFFSET_Y=4
  ANGLE_STEPS=90


  # Initialisor
  def initialize args

    # Spawn ourselves in the middle of the world
    @player_x = World::WORLD_WIDTH / 2
    @player_y = World::WORLD_HEIGHT / 2
    @angle = 0
    @momentum_x = 0.0
    @momentum_y = 0.0

    @bullet_weight = 0.2

  end


  # Update handler
  def update args

    # Deal with any user input - turning first
    if args.inputs.keyboard.key_down.left || args.inputs.keyboard.key_down.a
      @angle = ( @angle == 360 - ANGLE_STEPS ) ? 0 : @angle + ANGLE_STEPS
    end
    if args.inputs.keyboard.key_down.right || args.inputs.keyboard.key_down.d
      @angle = ( @angle == 0 ) ? 360 - ANGLE_STEPS : @angle - ANGLE_STEPS
    end

    # And then firing, in the direction we're facing
    if args.inputs.keyboard.key_down.space || args.inputs.keyboard.key_down.w

      # Two things happen we we shoot. First, a bullet is (obviously) spawned
      args.state.bullets << Bullet.new( 
        args, 
        @angle, 
        @player_x + @angle.vector_x(2), 
        @player_y + @angle.vector_y(2), 
        @angle.vector_x, 
        @angle.vector_y 
      )

      # And then we apply recoil in the other direction, bumping up the momentum
      # along the reverse vector
      @momentum_x -= @angle.vector_x @bullet_weight
      @momentum_y -= @angle.vector_y @bullet_weight

    end

    # Ask the world to update the momentum, taking the player's position into
    # consideration. 
    @momentum_x = args.state.world.check_x @player_x, @momentum_x
    @momentum_y = args.state.world.check_y @player_y, @momentum_y

    # Apply any resulting momentum
    @player_x += @momentum_x
    @player_y += @momentum_y

    # And update the camera to reflect it
    args.state.world.set_camera @player_x, @player_y

  end


  # Render handler
  def render args

    # Translate our location from world to camera co-ordinates
    my_x, my_y = args.state.world.world_to_camera @player_x, @player_y

    args.lowrez.sprites << {
      x: my_x - PLAYER_OFFSET_X,
      y: my_y - PLAYER_OFFSET_Y,
      w: PLAYER_WIDTH,
      h: PLAYER_HEIGHT,
      path: "sprites/player-#{args.state.world.direction(@angle)}.png",
    }

  end


end