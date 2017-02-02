require 'io/console'

class Trex

  ASCII_IMAGE = [File.readlines("lib/t-rex0"), File.readlines("lib/t-rex1")].freeze
  IMAGE_WIDTH = 22

  # main method - trex going in loop
  def gogo(timer = 0.1)
    @timer = timer
    puts "\e[H\e[2J" # clear shell
    token = true # for switch between images
    token = passage_0(token)
    loop do
      token = passage_1(token)
      token = passage_2(token)
    end
  end

  private

    # come from right border (bool -> bool)
    def passage_0(token)
      track = 0 # counter for moving image
      IMAGE_WIDTH.times do
        check_min_shell_width
        space_sum = shell_width - track - 1
        track, token = step(track, token) {
          |x| ASCII_IMAGE[x].map { |i| " " * space_sum + i[0..track] }
        }
      end
      token
    end

    # run from right to left border (bool -> bool)
    def passage_1(token)
      track = 0
      while (shell_width - IMAGE_WIDTH - 1) > track do
        check_min_shell_width
        space_sum = shell_width - track - IMAGE_WIDTH - 1
        track, token = step(track, token) {
          |x| space_sum == 0 ? ASCII_IMAGE[x] : ASCII_IMAGE[x].map { |i| " " * space_sum + i }
        }
      end
      token
    end

    # runaway to left and come from right border (bool -> bool)
    def passage_2(token)
      track = 0
      IMAGE_WIDTH.times do
        check_min_shell_width
        space_sum = shell_width - IMAGE_WIDTH - 1
        track, token = step(track, token) {
          |x| ASCII_IMAGE[x].map { |i| i[track..-2] + " " * space_sum + i[0..track] }
        }
      end
      token
    end

    # ( -> num)
    def shell_width
      $stdin.winsize[1]
    end

    # (num, bool -> num, bool)
    def step(track, token)
      x = token ? 1 : 0
      puts yield(x)
      sleep(@timer)
      puts "\e[H\e[2J" # clear shell
      return track + 1, !token
    end

    # check shell_width <= IMAGE_WIDTH in loop
    def check_min_shell_width
      while shell_width <= IMAGE_WIDTH do
        puts "\nYOU\nSHOULD\nINCREASE\nSHELL\nWIDTH"
        sleep(1)
      end
    end

end
