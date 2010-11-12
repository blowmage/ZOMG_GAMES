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
end

DemoGame.new.show