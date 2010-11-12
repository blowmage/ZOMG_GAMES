require 'rubygems'
require 'gosu'

class Ninja
  def initialize window
    @window = window
    @image = Gosu::Image.new window, 'assets/ninja-head.png'
  	@x = (window.width - @image.width) / 2
  	@y = (window.height - @image.height) / 2
  end
  def draw
    x = @x + (Math::cos(Time.now) + Math::sin(Time.now.to_f))*200
    y = @y + Math::sin(Time.now)*20
    @image.draw x, y, @image.height + y
  end
end

class Ruby
  def initialize window
    @window = window
    @image = Gosu::Image.new window, 'assets/ruby.png'
  	@x = (window.width - @image.width) / 2
  	@y = (window.height - @image.height) / 2
  end
  def draw
    x = @x + Math::sin(Time.now)*200
    y = @y + Math::tan(Time.now)*25
    @image.draw x, y, @image.height + y
  end
end

class DemoGame < Gosu::Window
  def initialize width=800, height=600, fullscreen=false
    super
    self.caption = 'O HAI RUBCONF!!1!'
    @background = Gosu::Image.new self, 'assets/japan.png'
    @ninja = Ninja.new self
    @ruby = Ruby.new self
  end
  
  def button_down id
    close if id == Gosu::KbEscape
  end
  
  def update
  end
  
  def draw
    @background.draw 0, 0, 0
    @ninja.draw
    @ruby.draw
  end
end

DemoGame.new.show