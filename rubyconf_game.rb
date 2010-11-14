require 'rubygems'
require 'gosu'

require './rubyconf_game/play_level'
require './rubyconf_game/win_level'
require './rubyconf_game/fail_level'

class RubyConfGame < Gosu::Window
  attr_reader :time
  def initialize width=800, height=600, fullscreen=false
    super

    self.caption = 'ESCAPE TO RUBYCONF!!!'

    @play = PlayLevel.new self
    @win  = WinLevel.new  self
    @fail = FailLevel.new self

    @play.start_level!
    @last_state == @play.state
  end

  def button_down id
    close if id == Gosu::KbEscape
  end
  
  def play?
    @play.state == :play
  end
  def win?
    @play.state == :win
  end
  def fail?
    @play.state == :fail
  end
  
  def state_changed?
    @last_state != @play.state
  end
  
  # I don't like how the state change happens implicity here
  # I'd like a better mechanism for state change, so we can
  # be more explicit about when to play sounds and stuff...
  def update
    @time = Time.now.to_f
    @play.update if play?
    if win?
      if state_changed?
        @win.difficulty = @play.difficulty
        @win.announce!
      end
      if button_down? Gosu::KbSpace
        # Increase difficulty
        @play.add_snake!
        @play.start_level!
      end
    elsif fail?
      @fail.announce! if state_changed?
      # Restart same difficulty
      @play.start_level! if button_down? Gosu::KbSpace
    end
    @last_state = @play.state
  end

  def draw
    if @play.state == :fail
      @fail.draw
    elsif @play.state == :win
      @win.draw
    else
      @play.draw
    end
  end
end

RubyConfGame.new.show