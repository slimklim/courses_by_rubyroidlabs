class GameLife

  LIVE = '*'
  DEAD = '-'

  # change space on next step (arr, num, num -> arr)
  def self.step(space, cols, rows)
    space.map.with_index do |row, yy|
      row.map.with_index do |cell, xx|
        x, y = tor(xx, rows), tor(yy, cols)
        summ = neighbors(space, x, y).delete(DEAD).size
        new_cell(cell, summ)
      end
    end
  end

  # return array with random values from 'val' (arr, arr -> arr)
  def self.random_space(space, val)
    space.map do |row|
      row.map do |cell|
        val[rand(2)]
      end
    end
  end

  # (tempfile -> arr, num, num)
  def self.load_file(file)
    space = file.readlines
    space.map! { |s| s.chomp }
    chars_space = space.map { |s| s.chars }.flatten.uniq
    raise RuntimeError.new('The file must contain only two types of symbols.') if chars_space.size > 2
    min = space[0].size
    space.each { |i| min = i.size if i.size < min }
    rows = space.size
    cols = min
    space.map! { |s| s.chars }
    return space.transpose, cols, rows
  end

  private

    # for imitation of the torus surface (num, num -> num)
    def self.tor(dd, max)
      dd == max - 1 ? -1 : dd
    end

    # (arr, num, num -> str) # x.y for image = y.x for array
    def self.neighbors(space, x, y)
      space[y-1][x-1] + space[y][x-1] + space[y+1][x-1] +
      space[y-1][x+1] + space[y][x+1] + space[y+1][x+1] +
      space[y-1][x] + space[y+1][x]
    end

    # calculate status of cell on next step (str, num -> str)
    def self.new_cell(cell, summ)
      if cell == DEAD
        summ == 3 ? LIVE : DEAD
      else
        (2..3).include?(summ) ? LIVE : DEAD
      end
    end

end