require 'gosu'

class PatrolPlayer
  attr_accessor :x, :y, :movement, :color
  def initialize window
    @window = window
    @movement = 2.5
    @circle = Gosu::Image.new window, 'assets/circle.png'
    @color = Gosu::Color::WHITE
    @x, @y = @circle.width/2, @circle.height/2
    @bounds = [ [ @circle.width/2 - 0.49,
                  @circle.height/2 - 0.49],
                [ @window.width - @circle.width/2 + 0.49,
                  @window.height - @circle.height/2 + 0.49 ]]
  end

  def current_angle
    a = nil
    if @window.button_down? Gosu::KbRight
      if @window.button_down? Gosu::KbUp
        a = 45
      elsif @window.button_down? Gosu::KbDown
        a = 135
      else
        a = 90
      end
    elsif @window.button_down? Gosu::KbLeft
      if @window.button_down? Gosu::KbUp
        a = 315
      elsif @window.button_down? Gosu::KbDown
        a = 225
      else
        a = 270
      end
    elsif @window.button_down? Gosu::KbUp
      a = 0
    elsif @window.button_down? Gosu::KbDown
      a = 180
    end
    a
  end

  def update
    a = current_angle
    if a
      @x += Gosu.offset_x a, @movement
      @y += Gosu.offset_y a, @movement
    end
    @x = @bounds[0][0] if @x < @bounds[0][0]
    @y = @bounds[0][1] if @y < @bounds[0][1]
    @x = @bounds[1][0] if @x > @bounds[1][0]
    @y = @bounds[1][1] if @y > @bounds[1][1]
  end
  
  def draw
    # The image needs to be drawn offset from the center x and y coordinates
    x = @x - @circle.width/2
    y = (@y - @circle.height/2)/2 + 200
    
    @circle.draw x, y, 1, 1.0, 0.5, @color
  end
end