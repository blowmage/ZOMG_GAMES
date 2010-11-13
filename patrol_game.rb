require 'rubygems'
require 'gosu'

require './patrol_creep'

class PatrolGame < Gosu::Window
  def initialize width=800, height=600, fullscreen=false
    super
    
    @creep = PatrolCreep.new self
    @creep.color = Gosu::Color::RED
  end
  
  def button_down id
    close if id == Gosu::KbEscape
  end
  
  def update
    @creep.update
  end
  
  def draw
    @creep.draw
  end
end

PatrolGame.new.show