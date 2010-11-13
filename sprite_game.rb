require 'rubygems'
require 'gosu'

class SnakeSprite
  attr_accessor :x, :y, :width, :height
  def initialize window, width=256, height=256
    @window = window
    @width, @height = width, height
    @direction = :right
    # Center the sprite by default
    @x, @y = (window.width - width)/2, (window.height - height)/2
    @tiles = Gosu::Image.load_tiles window,
                                    'assets/snake-walk-attack.png',
                                    @width, @height, false
    @states = { :walk   => { :movement => 4,       :speed => 0.35,
                             :frames   => [0,1],   :time => 0.0 },
                :attack => { :movement => 2,       :speed => 0.5,
                             :frames   => [2,3,4], :time => 0.0 }}
  end

  def state
    @states[ attack? ? :attack : :walk ]
  end

  def attack?
    @states[:attack][:time] + @states[:attack][:speed] > @window.time
  end
  
  def walk?
    !attack?
  end
  
  def attack!
    @states[:attack][:time] = @window.time unless attack?
  end

  def move_right
    @direction = :right
    @x += state[:movement]
  end
  
  def move_left
    @direction = :left
    @x -= state[:movement]
  end
  
  def draw
    if @direction == :right
      @tiles[frame].draw(@x, @y, 0, 1.0, 1.0)
    else
      @tiles[frame].draw(@x + @width, @y, 0, -1.0, 1.0)
    end
  end
  
  def frame
    d = (@window.time - state[:time]) / state[:speed] % 1
    state[:frames][(d * state[:frames].size).to_i]
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