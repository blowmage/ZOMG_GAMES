require 'gosu'

require './rubyconf_game/ninja'
require './rubyconf_game/snake'

class PlayLevel # inherit from Level? why?!?
  attr_accessor :window, :state, :sounds
  def initialize window
    @window = window

    @begin = Gosu::Sample.new @window, 'assets/begin.wav'

    # Create level elements
    @background = Gosu::Image.new @window, 'assets/rubyconf-background.png'
    @ninja = Ninja.new self
    @snakes = []
    3.times { add_snake! }

    # Set ninja start and win positions
    offset = @ninja.boundary/2
    @start_position = [offset, offset]
    @win_position   = [@window.width - offset, @window.height - offset]

    # Add callback holders
    # @start_callbacks = []
    @win_callbacks  = []
    @fail_callbacks = []
    @quit_callbacks = []
  end

  # def on_start &block
  #   @start_callbacks << block
  # end

  def on_win &block
    @win_callbacks << block
  end

  def on_fail &block
    @fail_callbacks << block
  end

  def on_quit &block
    @quit_callbacks << block
  end

  def start!
    # @start_callbacks.each { |c| c.call }
    @ninja.x = @start_position[0]
    @ninja.y = @start_position[1]
    @snakes.each do |snake|
      snake.start *rand_position
      snake.end   *rand_position
    end
    play_begin_sound
  end

  def play_begin_sound
    @begin.play
  end

  def rand_position
    x, y = 0, 0
    begin
      x, y = rand(@window.width), rand(@window.height)
    end while ((x < 120 && y < 120) ||
               (x > @window.width-120 && y > @window.height-120))
    [x, y]
  end

  def ninja_escaped?
    c = @ninja.center
    ( (c.first == @win_position.first) &&
      (c.last == @win_position.last) )
  end

  def snakes_count
    @snakes.size
  end

  def add_snake!
    @snakes << Snake.new(self)
  end

  def win!
    @ninja.stop_sneak
    @win_callbacks.each { |c| c.call }
  end

  def fail!
    @ninja.stop_sneak
    @fail_callbacks.each { |c| c.call }
  end

  def quit!
    @ninja.stop_sneak
    @quit_callbacks.each { |c| c.call }
  end

  def update
    quit! if @window.button_down? Gosu::KbEscape
    @ninja.update
    @snakes.each { |snake| snake.update }
    # Did the player make it?
    if ninja_escaped?
      win!
      return
    end
    # Check for collision and attacks
    nx, ny = @ninja.center
    @snakes.each do |snake|
      cx, cy = snake.center
      d = Gosu.distance nx, ny, cx, cy
      fail! if d < snake.range
      snake.attack! if d < snake.range*3
    end
  end

  def draw
    @background.draw 0, 0, 0
    @ninja.draw
    @snakes.each { |snake| snake.draw }
  end
end