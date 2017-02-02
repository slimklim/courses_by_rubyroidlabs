require 'colored'

class Searcher

  def initialize(str, selected_files, options)
    @search_string = options[:reg_ex] ?
      Regexp.new(str) : str
    @selected_files = selected_files
    @picking = around?(options[:around_str])
    @zip = options[:zip]
  end

  # main method ( -> arr)
  def search
    result = []
    @selected_files.each do |filename, file|
      text = unzip(filename, file)
      break unless text # skip file if not enable option '-z'
      text.delete("\n") # delete blank lines
      t = text.clone
      text.map!.with_index do |current_str, i|
        @picking.call(current_str, i, t) if current_str.index(@search_string)
      end
      result << text.compact << "_______end of file".green_on_blue + " '#{filename}'".yellow_on_blue
    end
    result
  end

  private

    # select logic depending on the choice of option -A (num -> proc)
    def around?(around_quantity)
      if around_quantity
        Proc.new { |current_str, i, text| with_around(current_str, i, text, around_quantity) }
      else
        Proc.new { |current_str| [red_str(current_str)] }
      end
    end

    # (str -> str)
    def red_str(full_str)
      full_str.gsub(@search_string) { |word| word.red }
    end

    # logic of picking strings (str, num, arr, num -> arr)
    def with_around(current_str, i, text, around_quantity)
      prev = (i >= around_quantity) ? # chek count lines previous line with search string
        (i - around_quantity ... i) : (0 ... i)
      after = (i + around_quantity <= text.size) ?  # chek count lines after line with search string
        (i + 1 .. i + around_quantity) : (i + 1 .. text.size)

      [text[prev],
      red_str(current_str),
      text[after],
      '---'.red_on_green].
        flatten
    end

    # read file, zip or nozip (str, file -> arr)
    def unzip(filename, file)
      if filename[-3..-1] == '.gz' # check file is ziped
        Zlib::GzipReader.open(file) { |gz| file = gz.readlines } if @zip # check option '-z'
      else
        file.readlines
      end
    end

end