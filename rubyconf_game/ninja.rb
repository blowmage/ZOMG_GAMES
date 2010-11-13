require 'gosu'
require './rubyconf_game/round'

class Ninja
  attr_accessor :x, :y, :width, :height, :boundary
  def initialize level, width=128, height=128, boundary=80
    @level = level
    @width, @height = width, height
    # x and y are the center of the bounds
    @x, @y = 0, 0
    @boundary = boundary
    @tiles = Gosu::Image.load_tiles @level.window,
                                    'assets/ninja.png',
                                    @width, @height, false
    @direction = :right
    @state = :idle
    @states = { :walk   => { :frames => [1,2,3,4], :speed => 0.5,
                             :movement => 5,       :time => 0.0 },
                :idle   => { :frames => [0],       :speed => 1.0,
                             :movement => 0,       :time => 0.0 } }
    @bounds = [ [ @boundary/2 - 0.49, @boundary/2 - 0.49 ],
                [ @level.window.width - @boundary/2 + 0.49,
                  @level.window.height - @boundary/2 + 0.49] ]

    @sneak = Gosu::Sample.new @level.window, 'assets/ninja-walk.wav'
    @sneak_impl = nil
  end

  def state
    @states[idle? ? :idle : :walk]
  end

  def idle?
    @state == :idle
  end

  def walk?
    !idle?
  end

  def frame
    (((@level.window.time - state[:time]) / state[:speed] % 1) * state[:frames].size).to_i + state[:frames].first
  end

  def center
    [Math::round(@x), Math::round(@y)]
  end

  def play_sneak
    if @sneak_impl.nil?
      @sneak_impl = @sneak.play 1, 1, true
    end
  end

  def stop_sneak
    @sneak_impl.stop if @sneak_impl
    @sneak_impl = nil
  end

  def update
    a = current_angle
    if a
      @state = :walk
      @direction = direction_from_angle a
      @x += Gosu::offset_x a, state[:movement]
      @y += Gosu::offset_y a, state[:movement]
      play_sneak
    else
      @state = :idle
      stop_sneak
    end
    @x = @bounds[0][0] if @x < @bounds[0][0]
    @x = @bounds[1][0] if @x > @bounds[1][0]
    @y = @bounds[0][1] if @y < @bounds[0][1]
    @y = @bounds[1][1] if @y > @bounds[1][1]
  end

  def current_angle
    angle = nil
    if @level.window.button_down? Gosu::KbRight
      if @level.window.button_down? Gosu::KbUp
        45
      elsif @level.window.button_down? Gosu::KbDown
        angle = 135
      else
        angle = 90
      end
    elsif @level.window.button_down? Gosu::KbLeft
      if @level.window.button_down? Gosu::KbUp
        angle = 315
      elsif @level.window.button_down? Gosu::KbDown
        angle = 225
      else
        angle = 270
      end
    elsif @level.window.button_down? Gosu::KbUp
      angle = 0
    elsif @level.window.button_down? Gosu::KbDown
      angle = 180
    end
    angle
  end

  def direction_from_angle a
    (a >= 0 && a <= 180) ? :right : :left
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