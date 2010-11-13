require 'gosu'

class WinLevel
  attr_accessor :window, :difficulty
  def initialize window
    @window = window
    @win = Gosu::Image.new @window, 'assets/win.png'
    @sound = Gosu::Sample.new @window, 'assets/win.wav'
  end

  def announce!
    @sound.play
  end

  def difficulty= d
    @difficulty = d
    @msg = Gosu::Image.from_text @window,
                                "You are a RUBY NINJA ROCKSTAR!!1!\n" +
                                "You defeated #{difficulty} enemies!!!\n" +
                                "Press SPACE if you dare to continue...\n" +
                                "Or ESCAPE if it is just too much for you.",
                                Gosu::default_font_name, 24
    @msg_x = @window.width/2 - @msg.width/2
    @msg_y = @window.height * 2 / 3
  end

  def update
  end

  def draw
    c = Math.cos(@window.time*4)
    a = Math.cos(@window.time)
    @win.draw_rot(((@window.width)/2), ((@window.height)/2 - 80), 1, a,
                  0.5, 0.5, 1.0+c*0.25, 1.0+c*0.25)

    @msg.draw @msg_x, @msg_y, 1, 1.0, 1.0, Gosu::Color::RED if @msg
  end
end