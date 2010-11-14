require 'gosu'

class WinLevel
  attr_accessor :window, :difficulty
  def initialize window
    @window = window
    @win = Gosu::Image.new @window, 'assets/win.png'
    @sound = Gosu::Sample.new @window, 'assets/win.wav'

    # Add callback holders
    @continue_callbacks = []
    @quit_callbacks = []
  end

  def on_continue &block
    @continue_callbacks << block
  end

  def on_quit &block
    @quit_callbacks << block
  end

  def start!
    @sound.play
    create_msg!
  end

  def continue!
    @continue_callbacks.each { |c| c.call }
  end

  def quit!
    @quit_callbacks.each { |c| c.call }
  end

  def create_msg!
    @msg = Gosu::Image.from_text @window,
                                "You are a RUBY NINJA ROCKSTAR!!1!\n" +
                                "You avoided #{@window.snakes_count} snakes!!!\n" +
                                "Press SPACE if you dare to continue...\n" +
                                "Or ESCAPE if it is just too much for you.",
                                Gosu::default_font_name, 24
    @msg_x = @window.width/2 - @msg.width/2
    @msg_y = @window.height * 2 / 3
  end

  def update
    quit!     if @window.button_down? Gosu::KbEscape
    continue! if ( @window.button_down? Gosu::KbSpace)
                   # @window.button_down? Gosu::KbReturn ||
                   # @window.button_down? Gosu::KbEnter )
  end

  def draw
    c = Math.cos(@window.time*4)
    a = Math.cos(@window.time)
    @win.draw_rot(((@window.width)/2), ((@window.height)/2 - 80), 1, a,
                  0.5, 0.5, 1.0+c*0.25, 1.0+c*0.25)

    @msg.draw @msg_x, @msg_y, 1, 1.0, 1.0, Gosu::Color::RED if @msg
  end
end