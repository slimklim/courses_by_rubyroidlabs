class GameLife

  LIVE = '*'
  DEAD = '-'

  attr_reader :space

  def initialize(filename: "lib/gospers_glider_gun")
    @space = File.readlines(filename).map(&:chomp)
    chars_space = @space.map { |s| s.chars }.flatten!.uniq!
    raise RuntimeError.new('The file must contain only two types of symbols.') if chars_space.size > 2
    min = @space[0].size
    @space.each { |i| min = i.size if i.size < min }
    @rows = @space.size
    @cols = min
  end

  # change @space on next step
  def step()
    @space = @space.map.with_index do |row, yy|
      row_arr = row.chars.map.with_index do |cell, xx|
        x, y = tor(xx, @cols), tor(yy, @rows)
        summ = neighbors(x, y).delete(DEAD).size
        new_cell(cell, summ)
      end
      row_arr.join
    end
  end

  # main method (num -> )
  def loop(timer: 0.1)
    loop do
      puts "\e[H\e[2J"
      puts step()
      sleep(timer)
    end
  end

  private

    # for imitation of the torus surface (num, num -> num)
    def tor(dd, max)
      dd == max - 1 ? -1 : dd
    end

    # (num, num -> str) # x.y for image = y.x for array
    def neighbors(x, y)
      @space[y-1][x-1] + @space[y][x-1] + @space[y+1][x-1] +
      @space[y-1][x+1] + @space[y][x+1] + @space[y+1][x+1] +
      @space[y-1][x] + @space[y+1][x]
    end

    # calculate status of cell on next step (str, num -> str)
    def new_cell(cell, summ)
      if cell == DEAD
        summ == 3 ? LIVE : DEAD
      else
        (2..3).include?(summ) ? LIVE : DEAD
      end
    end

end