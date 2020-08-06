# world.rb - part of LRTank
#
# Defines the world

class World

  WORLD_WIDTH = 512
  WORLD_HEIGHT = 512
  FRICTION=255


  # Initialisor
  def initialize args

    # Set up some basic defaults; put the camera in the middle of the world
    @camera_x = ( WORLD_WIDTH - SCREEN_WIDTH ) / 2
    @camera_y = ( WORLD_HEIGHT - SCREEN_HEIGHT ) / 2


    # We'll render a nice landscape into a render_target, so we can blit it
    # around easily later and make it easy to scroll the camera around
    args.render_target( :render_land ).width = WORLD_WIDTH
    args.render_target( :render_land ).height = WORLD_HEIGHT

    # Just some backdrop stuff for now...
    0.step(WORLD_HEIGHT, 8) do |i|

      args.render_target( :render_land ).primitives << {
        x: 0, y: i,
        x2: WORLD_WIDTH, y2: i,
        r: 200, g: 200, b: 200,
      }.line

      args.render_target( :render_land ).primitives << {
        x: i, y: 0,
        x2: i, y2: WORLD_HEIGHT,
        r: 200, g: 200, b: 200,
      }.line

    end

  end


  # Update handler
  def update args

  end


  # Translate angles to compass points. This is universal, but it feels right
  # to put it in the world
  def direction angle

    case angle
    when 0
      'e'
    when 45
      'ne'
    when 90
      'n'
    when 135
      'nw'
    when 180
      'w'
    when 225
      'sw'
    when 270
      's'
    when 315
      'se'
    end

  end


  # Position the camera based on player position
  def set_camera player_x, player_y

    # Start by putting the player in the middle of the screen
    @camera_x = player_x - ( SCREEN_WIDTH / 2 )
    @camera_y = player_y - ( SCREEN_HEIGHT / 2 )

    # Then normalise so that we don't sail off the edge of the world
    if @camera_x < 0
      @camera_x = 0
    end
    if @camera_x > ( WORLD_WIDTH - SCREEN_WIDTH )
      @camera_x = WORLD_WIDTH - SCREEN_WIDTH
    end
    if @camera_y < 0
      @camera_y = 0
    end
    if @camera_y > ( WORLD_HEIGHT - SCREEN_HEIGHT )
      @camera_y = WORLD_HEIGHT - SCREEN_HEIGHT
    end
  end


  # Convert world co-ordinates to camera co-ordinates
  def world_to_camera x, y

    return x - @camera_x, y - @camera_y

  end


  # Check the x momentum of the player, apply any bouncing or friction
  def check_x player, momentum

    # Check the edge of the board, and bounce if required
    if momentum.negative?
      if ( player + momentum ) < 0
        momentum *= -1
      end
    else
      if ( player + momentum ) > WORLD_WIDTH
        momentum *= -1
      end
    end

    # Add a touch of friction
    if momentum.nonzero?
      momentum -= momentum / FRICTION
    end

    momentum

  end

  def check_y player, momentum

    # Check the edge of the board, and bounce if required
    if momentum.negative?
      if ( player + momentum ) < 0
        momentum *= -1
      end
    else
      if ( player + momentum ) > WORLD_HEIGHT
        momentum *= -1
      end
    end

    # Add a touch of friction
    if momentum.nonzero?
      momentum -= momentum / FRICTION
    end

    momentum

  end


  # Render handler
  def render args

    args.lowrez.sprites << {
      x: 0,
      y: 0,
      w: 64,
      h: 64,
      source_x: @camera_x, source_y: @camera_y,
      source_w: 64, source_h: 64,
      path: :render_land,
    }

  end


end