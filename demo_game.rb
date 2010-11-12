require 'rubygems'
require 'gosu'

class DemoGame < Gosu::Window
  def initialize width=800, height=600, fullscreen=false
    super
    self.caption = 'O HAI RUBCONF!!1!'
  end
  
  def button_down id
    close if id == Gosu::KbEscape
  end
  
  def update
  end
  
  def draw
    # Let's draw a square!
    w, h = 200, 200
    x = self.width/2 - w/2
    y = self.height/2 - h/2
    # Let's animate it!
    x += (Math.sin(Time.now) + Math.cos(Time.now))*200
    y += Math.tan(Time.now)*20
    draw_rect x, y, x+w, y+h, Gosu::Color::WHITE
  end
  
  def draw_rect x1, y1, x2, y2, c
    draw_quad x1, y1, c,
              x2, y1, c,
              x1, y2, c,
              x2, y2, c
  end
end

DemoGame.new.show