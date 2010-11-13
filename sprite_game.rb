require 'rubygems'
require 'gosu'

class SnakeSprite
  attr_accessor :x, :y, :width, :height
  def initialize window, width=256, height=256
    @window = window
    @width, @height = width, height
    @direction = :right
    @movement = 4
    @animation_speed = 0.35
    # Center the sprite by default
    @x, @y = (window.width - width)/2, (window.height - height)/2
    @tiles = Gosu::Image.load_tiles window,
                                    'assets/snake-walk-attack.png',
                                    @width, @height, false
    @walk_movement = 4
    @walk_speed = 0.35
    @walk_frames = 2
    @attack_speed = 0.5
    @attack_frames = 3
    @attack_time = 0.0
  end

  def attack?
    @attack_time + @attack_speed > @window.time
  end
  
  def walk?
    !attack?
  end
  
  def attack!
    @attack_time = @window.time unless attack?
  end

  def move_right
    if walk?
      @direction = :right
      @x += @movement
    end
  end
  
  def move_left
    if walk?
      @direction = :left
      @x -= @movement
    end
  end
  
  def draw
    if @direction == :right
      @tiles[frame].draw(@x, @y, 0, 1.0, 1.0)
    else
      @tiles[frame].draw(@x + @width, @y, 0, -1.0, 1.0)
    end
  end
  
  def frame
    if walk?
      ((@window.time / @walk_speed % 1) * @walk_frames).to_i
    else #attack!
      d = (@window.time - @attack_time) / @attack_speed % 1
      (d * @attack_frames).to_i + @walk_frames
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
    @snake.attack!    if button_down? Gosu::KbSpace
    @snake.move_right if button_down? Gosu::KbRight
    @snake.move_left  if button_down? Gosu::KbLeft
  end
  
  def draw
    @snake.draw
  end
end

SnakeGame.new.show