require 'gosu'
require './rubyconf_game/round'

class Snake
  attr_accessor :x, :y, :height, :width, :boundary, :range
  def initialize level, width=128, height=128, boundary=80
    @level = level
    @width, @height = width, height
    # x and y are the center of the bounds
    @range = @boundary = boundary
    @tiles = Gosu::Image.load_tiles @level.window,
                                    'assets/snake.png',
                                    @width, @height, false
    @direction = :right
    @state = :walk
    @states = { :walk   => { :frames => [0,1],   :speed => 0.25,
                             :movement => 6,     :time => 0.0 },
                :attack => { :frames => [2,3,4], :speed => 0.35,
                             :movement => 6,     :time => 0.0 } }
    self.start @level.window.width-@boundary, @boundary
    self.end   @boundary, @level.window.height-@boundary
    @target = :start # :start

    # Register the sound on the app because many snakes will hiss
    @level.sounds[:hiss] ||= Gosu::Sample.new @level.window,
                                              'assets/snake-hiss.wav'
  end

  def state
    @states[attack? ? :attack : :walk]
  end

  def attack!
    unless attack?
      @states[:attack][:time] = @level.window.time
      hiss
    end
  end

  def attack?
    @states[:attack][:time] + @states[:attack][:speed] > @level.window.time
  end

  def walk?
    !attack
  end

  def frame
    (((@level.window.time - state[:time]) / state[:speed] % 1) * state[:frames].size).to_i + state[:frames].first
  end

  def target
    (@target == :start) ? @start : @end # patrol state
  end

  def reverse!
    @target = (@target == :start) ? :end : :start
  end

  def at_target?
    ( (@x <= target.first + 0.5 && @x >= target.first - 0.5) &&
      (@y <= target.last  + 0.5 && @y >= target.last  - 0.5) )
  end

  def start x, y
    @x, @y = x, y
    @start = [x, y]
  end

  def end x, y
    @end = [x, y]
  end

  def center
    [Math::round(@x), Math::round(@y)]
  end

  def hiss
    @level.sounds[:hiss].play
  end

  def update
    a = Gosu::angle @x, @y, target.first, target.last
    xmd = Gosu::offset_x a, state[:movement]
    xsd = target.first - @x
    ymd = Gosu::offset_y a, state[:movement]
    ysd = target.last - @y
    @direction = (xmd < 0) ? :left : :right
    @x += (xmd.abs < xsd.abs) ? xmd : xsd
    @y += (ymd.abs < ysd.abs) ? ymd : ysd
    d = Gosu.distance @x, @y, target.first, target.last
    reverse! if at_target?
  end

  def draw
    x, y = center
    bx = x - @boundary/2
    by = (y - @boundary/2)/2+200
    px = bx - @width/2 + @boundary/2
    py = by - @height + @boundary/2
    factor_x = 1.0
    factor_y = 1.0
    if @direction == :left
      factor_x = -1.0
      px += @width
    end
    @tiles[frame].draw Math::round(px), Math::round(py), (by), factor_x, factor_y
  end
end