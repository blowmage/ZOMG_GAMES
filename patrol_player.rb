require 'gosu'

class PatrolPlayer
  attr_accessor :movement, :color
  def initialize window
    @window = window
    @movement = 2.5
    @circle = Gosu::Image.new window, 'assets/circle.png'
    @color = Gosu::Color::WHITE
    @x, @y = @circle.width/2, @circle.height/2
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
  end
  
  def draw
    # The image needs to be drawn offset from the center x and y coordinates
    x, y = @x - @circle.width/2, @y - @circle.height/2
    @circle.draw x, y, 1, 1.0, 1.0, @color
  end
end