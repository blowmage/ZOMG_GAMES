require 'rubygems'
require 'gosu'

class SnakeSprite
  attr_accessor :x, :y, :width, :height
  def initialize window, width=256, height=256
    @window = window
    @width, @height = width, height
    @direction = :right
    @movement = 4
    # Center the sprite by default
    @x, @y = (window.width - width)/2, (window.height - height)/2
    @tiles = Gosu::Image.load_tiles window,
                                    'assets/snake-walk.png',
                                    @width, @height, false
  end

  def move_right
    @direction = :right
    @x += @movement
  end
  
  def move_left
    @direction = :left
    @x -= @movement
  end
  
  def draw
    if @direction == :right
      @tiles[0].draw(@x, @y, 0, 1.0, 1.0)
    else
      @tiles[0].draw(@x + @width, @y, 0, -1.0, 1.0)
    end
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
    @snake.move_right if button_down? Gosu::KbRight
    @snake.move_left  if button_down? Gosu::KbLeft
  end
  
  def draw
    @snake.draw
  end
end

SnakeGame.new.show