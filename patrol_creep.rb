require 'gosu'

class PatrolCreep
  attr_accessor :x, :y, :movement, :color, :start, :end, :range
  def initialize window
    @window = window
    @movement = 3.5
    @circle = Gosu::Image.new window, 'assets/circle.png'
    @color = Gosu::Color::WHITE
    # x and y are the center of the creep
    # default to the center of the window
    @x, @y = @window.width/2, @window.height/2
    @start = [ @circle.width, @circle.height ]
    @end   = [ @window.width - @circle.width,
               @window.height - @circle.height ]
    @target = :end
    @range = @circle.width
  end
    
  def target
    @target == :start ? @start : @end
  end
  
  def reverse!
    @target = (@target == :start) ? :end : :start
  end
  
  def start x, y
    @x, @y = x, y
    @start = [x, y]
  end
  
  def end x, y
    @end = [x, y]
  end
  
  def near_target?
    d = Gosu.distance @x, @y, target.first, target.last
    d < @movement
  end
  
  def update
    a = Gosu.angle @x, @y, target.first, target.last
    @x += Gosu.offset_x a, @movement
    @y += Gosu.offset_y a, @movement
    reverse! if near_target?
  end
  
  def draw
    # The image needs to be drawn offset from the center x and y coordinates
    x = @x - @circle.width/2
    y = (@y - @circle.height/2)/2 + 200
    
    @circle.draw x, y, 1, 1.0, 0.5, @color
  end
end