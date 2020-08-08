# turret.rb - part of LRTank
#
# Defines turrets!

class Turret

  # Attributes
  attr_accessor :turret_x, :turret_y, :angle


  # Some useful constants
  TURRET_WIDTH=9
  TURRET_HEIGHT=9
  TURRET_OFFSET_X=4
  TURRET_OFFSET_Y=4


  # Initialisor
  def initialize args

    # Position ourself somewhere random; should probably make sure we don't
    # either overlap another turret, or land visible to the player
    @angle = 0
    @turret_x = TURRET_OFFSET_X + rand(World::WORLD_WIDTH-TURRET_WIDTH)
    @turret_y = TURRET_OFFSET_Y + rand(World::WORLD_HEIGHT-TURRET_HEIGHT)

  end


  # Update handler 
  def update args


  end



  # Render handler
  def render args

    # All turrets look the same, but face in different directions :)
    my_x, my_y = args.state.world.world_to_camera @turret_x, @turret_y
    args.lowrez.sprites << {
      x: my_x - TURRET_OFFSET_X,
      y: my_y - TURRET_OFFSET_Y,
      w: TURRET_WIDTH,
      h: TURRET_HEIGHT,
      path: "sprites/turret-#{args.state.world.direction(@angle)}.png",
    }

  end


end