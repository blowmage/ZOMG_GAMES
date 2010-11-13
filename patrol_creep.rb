require 'gosu'

class PatrolCreep
  attr_accessor :movement, :color, :start, :end
  def initialize window
    @window = window
    @movement = 3.5
    @circle = Gosu::Image.new window, 'assets/circle.png'
    @color = Gosu::Color::WHITE
    # x and y are the center of the creep
    # default to the center of the window
    @x, @y = @window.width/2, @window.height/2
  end
    
  def update
  end
  
  def draw
    # The image needs to be drawn offset from the center x and y coordinates
    x, y = @x - @circle.width/2, @y - @circle.height/2
    @circle.draw x, y, 1, 1.0, 1.0, @color
  end
end