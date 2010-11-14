require 'rubygems'
require 'gosu'

require './rubyconf_game/play_level'
require './rubyconf_game/win_level'
require './rubyconf_game/fail_level'

class RubyConfGame < Gosu::Window
  attr_reader :time, :sounds
  def initialize width=800, height=600, fullscreen=false
    super

    self.caption = 'ESCAPE TO RUBYCONF!!!'

    # So multiple sprites don't create duplicate objects
    @sounds = {}
    
    # Levels
    @play = PlayLevel.new self
    @win  = WinLevel.new  self
    @fail = FailLevel.new self

    # @play.on_start    { do_something_here! }
    @play.on_win      { win! }
    @play.on_fail     { fail! }
    @play.on_quit     { close }

    @fail.on_continue { play! }
    @fail.on_quit     { close }

    @win.on_continue  { @play.add_snake!; play!}
    @win.on_quit      { close }

    play!
  end

  def play!
    @level = @play
    @play.start!
  end

  def fail!
    @level = @fail
    @fail.start!
  end

  def win!
    @level = @win
    @win.start!
  end

  def button_down id
    @level.button_down id if @level.respond_to? :button_down
  end

  def button_up id
    @level.button_up id if @level.respond_to? :button_up
  end
  
  def snakes_count
    @play.snakes_count
  end

  def update
    @time = Time.now.to_f
    @level.update
  end

  def draw
    @level.draw
  end
end

RubyConfGame.new.show