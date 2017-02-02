class PolishCalculator

  def initialize
    @arguments = []
    @operators = []
    @counter = 0
    @calculate_method = 'simple_method'
  end

  def run
    input_arguments
    unless few_arguments?
      input_operators
      calculate
    end
  end

  private

    def calculate
      case @calculate_method
        when 'simple_method' then simple_method
        when 'nulled_bits_method' then nulled_bits_method
      end
    end

    def simple_method
      expression_for_eval = expression(@arguments.map { |a| "#{a}.to_f" })
      expression_for_str = expression(@arguments)
      puts "#{expression_for_str} = #{eval(expression_for_eval)}"
    end

    def nulled_bits_method
      num_b = @arguments[0].to_i.to_s(2)
      x = @arguments[1].to_i
      num_b[-x..-1] = '0'*x
      result = 0b0 + num_b.to_i(2)
      puts "result = #{result}"
    end

    def expression(args)
      [args, @operators].transpose.flatten.join(" ")
    end

    def few_arguments?
      if @counter < 2
        puts 'too few arguments!'
        true
      end
    end

    def not_argument?(arg)
      if (arg.to_i == 0) & (arg.chars.uniq.join != '0')
        @operators << arg if correct_operator?(arg)
        true
      else
        false
      end
    end

    def input_arguments
      loop do
        a = gets.chomp
        break if not_argument?(a)
        @counter += 1
        @arguments << "#{a}" if correct_argument?(a)
      end
    end

    def input_operators
      (@counter - 2).times do
        o = gets.chomp
        @operators << o if correct_operator?(o)
      end
      @operators << ""
    end

    def correct_argument?(arg)
      arg.chars.each do |char|
        unless "0123456789".include?(char)
          puts 'some arguments contain no numbers!'
          abort
        end
      end
      true
    end

    def correct_operator?(oper)
      unless "+-*/".include?(oper)
        if (@arguments.size == 2) & (oper == "!")
          @calculate_method = 'nulled_bits_method'
        else
          puts 'incorrect some operators'
          abort
        end
      end
      true
    end

end






