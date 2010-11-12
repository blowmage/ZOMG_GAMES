require 'rubygems'
require 'gosu'

class DemoGame < Gosu::Window
  def initialize width=800, height=600, fullscreen=false
    super
    self.caption = 'O HAI RUBCONF!!1!'
    @background = Gosu::Image.new self, 'assets/japan.png'
    @ninja = Gosu::Image.new self, 'assets/ninja-head.png'
  end
  
  def button_down id
    close if id == Gosu::KbEscape
  end
  
  def update
  end
  
  def draw
    @background.draw 0, 0, 0
    # Let's draw a square!
    x = self.width/2 - @ninja.width/2
    y = self.height/2 - @ninja.height/2
    # Let's animate it!
    x += (Math.sin(Time.now) + Math.cos(Time.now))*200
    y += Math.tan(Time.now)*20
    @ninja.draw x, y, 1
  end
  
  def draw_rect x1, y1, x2, y2, c
    draw_quad x1, y1, c,
              x2, y1, c,
              x1, y2, c,
              x2, y2, c
  end
end

DemoGame.new.show