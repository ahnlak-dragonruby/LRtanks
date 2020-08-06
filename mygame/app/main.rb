# LRTank; a LowRez Jam entry
#


# Import all our code

require 'app/lowrez.rb'
require 'app/world.rb'
require 'app/player.rb'
require 'app/bullet.rb'

SCREEN_WIDTH=64
SCREEN_HEIGHT=64


# Initialisation, sets everything back to a start-up state
def init args

  # Create the various objects
  args.state.world = World.new args
  args.state.player = Player.new args
  args.state.bullets = Array.new

end


# Update, updates the state of the world but does no rendering
def update args

  # Get the various state objects to update
  args.state.world.update args
  args.state.player.update args
  args.state.bullets.select! { |bullet| bullet.update args }

end


# Render, draws the current state of the world but applies no logic
def render args

  # Make sure the background is set to the right colour
  args.lowrez.background_color = [ 0, 0, 0 ]

  # Ask the state objects to render themselves
  args.state.world.render args
  args.state.player.render args
  args.state.bullets.each { |bullet| bullet.render args }

end


# Renders a useful bunch of debug information
def render_debug args
  if !args.state.grid_rendered
    65.map_with_index do |i|
      args.outputs.static_debug << {
        x:  LOWREZ_X_OFFSET,
        y:  LOWREZ_Y_OFFSET + (i * 10),
        x2: LOWREZ_X_OFFSET + LOWREZ_ZOOMED_SIZE,
        y2: LOWREZ_Y_OFFSET + (i * 10),
        r: 128,
        g: 128,
        b: 128,
        a: 80
      }.line

      args.outputs.static_debug << {
        x:  LOWREZ_X_OFFSET + (i * 10),
        y:  LOWREZ_Y_OFFSET,
        x2: LOWREZ_X_OFFSET + (i * 10),
        y2: LOWREZ_Y_OFFSET + LOWREZ_ZOOMED_SIZE,
        r: 128,
        g: 128,
        b: 128,
        a: 80
      }.line
    end
  end

  args.state.grid_rendered = true

  args.state.last_click ||= 0
  args.state.last_up    ||= 0
  args.state.last_click   = args.state.tick_count if args.lowrez.mouse_down # you can also use args.lowrez.click
  args.state.last_up      = args.state.tick_count if args.lowrez.mouse_up
  args.state.label_style  = { size_enum: -1.5 }

  args.state.watch_list = [
    "args.state.tick_count is:       #{args.state.tick_count}",
    "args.lowrez.mouse_position is:  #{args.lowrez.mouse_position.x}, #{args.lowrez.mouse_position.y}",
    "args.lowrez.mouse_down tick:    #{args.state.last_click || "never"}",
    "args.lowrez.mouse_up tick:      #{args.state.last_up || "false"}",
    "Player.player_x:          #{args.state.player.player_x.to_i}",
    "Player.player_y:          #{args.state.player.player_y.to_i}",
    "Player.angle:             #{args.state.player.angle.to_i}",
    "Active bullets:           #{args.state.bullets.length}",
  ]

  args.outputs.debug << args.state
                            .watch_list
                            .map_with_index do |text, i|
    {
      x: 5,
      y: 720 - (i * 20),
      text: text,
      size_enum: -1.5,
	    r: 250,
	    g: 250,
	    b: 250,
	    a: 250,
    }.label
  end

end


# Core tick handler, called every frame
def tick args

	# Start up initialisation - skip the first frame because, err, you can't build
  # render targets that early?
  if args.tick_count == 0
    return
  end
	if args.tick_count == 1
		init args
	end

	# Then keep things as clean as possible in an update/render cycle
	update args
	render args

	# Put out some debug information, comment out for release!
	render_debug args

end