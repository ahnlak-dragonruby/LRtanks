# bullet.rb - part of LRTank
#
# Defines bullets!

class Bullet

  # Attributes
  attr_accessor :bullet_x, :bullet_y, :angle


  # Some useful constants
  BULLET_WIDTH=5
  BULLET_HEIGHT=5
  BULLET_FRAMES=3
  BULLET_OFFSET_X=2
  BULLET_OFFSET_Y=2


  # Initialisor
  def initialize args, angle, bullet_x, bullet_y, momentum_x, momentum_y

    # Set our location as best we can
    @angle = angle
    @bullet_x = bullet_x
    @bullet_y = bullet_y
    @momentum_x = momentum_x
    @momentum_y = momentum_y
    @render_target = "render_bullet_#{args.state.world.direction(@angle)}".to_sym

    # We want a render target for this bullet's sprites. All bullets look the
    # same though, so we'll use the same render target.

    args.render_target( @render_target ).width = ( BULLET_WIDTH * BULLET_FRAMES )
    args.render_target( @render_target ).height = BULLET_HEIGHT

    # Load up the sprite which will contain a couple of frames side by side
    args.render_target( @render_target ).primitives << {
      x: 0, y: 0,
      w: BULLET_WIDTH * BULLET_FRAMES, h: BULLET_HEIGHT,
      path: "sprites/bullet-#{args.state.world.direction(@angle)}.png",
    }.sprite

  end


  # Update handler - return true if the bullet should continue to exist
  def update args

    # First off, apply the momentum
    @bullet_x += @momentum_x
    @bullet_y += @momentum_y

    # If the bullet has left the world, remove it
    if @bullet_x < 0 || @bullet_x > World::WORLD_WIDTH || @bullet_y < 0 || @bullet_y > World::WORLD_HEIGHT
      return false
    end

    # Then all is well, and the bullet should keep on trucking
    return true

  end



  # Render handler
  def render args

    # Work out which frame to be rendering
    frame_x = ( ( args.state.tick_count / 10 ).to_i % BULLET_FRAMES ) * BULLET_WIDTH
    frame_y = 0
    my_x, my_y = args.state.world.world_to_camera @bullet_x, @bullet_y

    args.lowrez.sprites << {
      x: my_x - BULLET_OFFSET_X,
      y: my_y - BULLET_OFFSET_Y,
      w: BULLET_WIDTH,
      h: BULLET_HEIGHT,
      source_x: frame_x, source_y: frame_y,
      source_w: BULLET_WIDTH, source_h: BULLET_HEIGHT,
      path: @render_target,
    }

  end


end