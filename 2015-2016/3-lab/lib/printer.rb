require 'yaml'
require 'colorize'
require 'io/console'

class Printer

  def initialize()
    @emo = YAML.load_file('lib/keywords.yml')
  end

  # main method (arr -> )
  def print(teacher_with_comments)
    teacher_with_comments.each do |teacher|
      print_teacher(teacher[:name])
      teacher[:comments].each { |comment| print_comment(comment) }
    end
  end

  private

  # (str -> num)
  def analyze(text)
    result = 0
    @emo[:positive].each { |keyword| result += 1 if text.downcase.index(' ' + keyword)}
    @emo[:negative].each { |keyword| result -= 1 if text.downcase.index(' ' + keyword)}
    result
  end

  # (str -> str)
  def colorize_comment(text)
    case analyze(text) <=> 0
      when -1 then text.red
      when 0 then text.white
      when 1 then text.green
    end
  end

  # (hash -> )
  def print_comment(comment)
    puts comment[:date]
    puts "-"*shell_width
    puts colorize_comment(comment[:text])
    puts "-"*shell_width
  end

  # (str -> )
  def print_teacher(name)
    puts "="*shell_width
    puts name.white.on_blue
    puts "_"*shell_width
  end

  # ( -> num)
  def shell_width
    $stdin.winsize[1]
  end

end