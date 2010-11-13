require 'gosu'

require './rubyconf_game/ninja'
require './rubyconf_game/snake'

class PlayLevel # inherit from Level? why?!?
  attr_accessor :window, :state, :sounds
  def initialize window
    @window = window

    # sounds
    @sounds = {}
    @begin = Gosu::Sample.new @window, 'assets/begin.wav'

    @background = Gosu::Image.new @window, 'assets/rubyconf-background.png'
    @ninja = Ninja.new self
    add_snake!;add_snake!;add_snake!
    offset = @ninja.boundary/2
    @start_position = [offset, offset]
    @win_position   = [@window.width - offset, @window.height - offset]
  end

  def add_snake!
    @snakes ||= []
    @snakes << Snake.new(self)
  end

  def start_level!
    @state = :play
    @ninja.x = @start_position[0]
    @ninja.y = @start_position[1]
    @snakes.each do |snake|
      snake.start *rand_position
      snake.end   *rand_position
    end
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

  def difficulty
    @snakes.size
  end

  def win!
    @ninja.stop_sneak
    @state = :win
  end

  def fail!
    @ninja.stop_sneak
    @state = :fail
  end

  def update
    if @state == :play
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
  end

  def draw
    if @state == :play
      @background.draw 0, 0, 0
      @ninja.draw
      @snakes.each { |snake| snake.draw }
    end
  end
end