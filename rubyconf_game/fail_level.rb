require 'gosu'

class FailLevel
  attr_accessor :window
  def initialize window
    @window = window
    @fail = Gosu::Image.new @window, 'assets/fail.png'
    @msg = Gosu::Image.from_text @window,
                                "You were defeated!\n" +
                                "Press ESCAPE to quit. Quitter\n" +
                                "Or SPACE to try again. Doubt it.",
                                Gosu::default_font_name, 24
    @msg_x = @window.width/2 - @msg.width/2
    @msg_y = @window.height * 2 / 3
    @sound = Gosu::Sample.new @window, 'assets/fail.wav'
  end

  def announce!
    @sound.play
  end

  def update
  end

  def draw
    c = Math.cos(@window.time*4)
    @fail.draw_rot(((@window.width)/2), ((@window.height)/2 - 80), 1, 0,
                  0.5, 0.5, 1.0+c*0.25, 1.0+c*0.25)
    s = Math.sin @window.time
    @msg.draw_rot( ((@window.width)/2 + (100*(s)).to_i),
                    ((@window.height)/2 + 160 + s*s*s.abs*50),
                    1, s*5, 0.5, 0.5,
                    1.0+(0.1*s*s*s.abs), 1.0+(0.1*s*s*s.abs),
                    Gosu::Color::RED )
  end
end