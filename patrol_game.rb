require 'rubygems'
require 'gosu'

require './patrol_player'
require './patrol_creep'

class PatrolGame < Gosu::Window
  def initialize width=800, height=600, fullscreen=false
    super
    
    @player = PatrolPlayer.new self
    @creeps = (0..5).map do
      creep = PatrolCreep.new self
      creep.color = random_color
      creep.start = *random_position
      creep.end   = *random_position
      creep
    end
  end

  def random_color
    color       = Gosu::Color.new 0xff000000
    color.red   = rand(255 - 40) + 40
    color.green = rand(255 - 40) + 40
    color.blue  = rand(255 - 40) + 40
    color
  end
  
  def random_position
    [ rand(self.width), rand(self.height) ]
  end
  
  def button_down id
    close if id == Gosu::KbEscape
  end
  
  def update
    @player.update
    @creeps.each { |creep| creep.update }
  end
  
  def draw
    @player.draw
    @creeps.each { |creep| creep.draw }
  end
end

PatrolGame.new.show