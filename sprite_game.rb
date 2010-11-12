require 'rubygems'
require 'gosu'

class SnakeSprite
  attr_accessor :x, :y, :width, :height
  def initialize window, width=256, height=256
    @window = window
    @width, @height = width, height
    # Center the sprite by default
    @x, @y = (window.width - width)/2, (window.height - height)/2
    @tiles = Gosu::Image.load_tiles window,
                                    'assets/snake-walk.png',
                                    @width, @height, false
  end

  def draw
    @tiles[0].draw(@x, @y, 0, 1.0, 1.0)
  end
end

class SnakeGame < Gosu::Window
  attr_accessor :time
  def initialize width=800, height=600, fullscreen=false
    super
    @snake = SnakeSprite.new self
  end
  
  def button_down id
    close if id == Gosu::KbEscape
  end
  
  def update
    @time = Time.now.to_f
  end
  
  def draw
    @snake.draw
  end
end

SnakeGame.new.show