# запоминает даты начала и конца семестра

require 'date'

module Telegram::Bot::Commands
  class Semester < Base

    DAYS_IN_MONTH = 31

    # entry dates in @semester_dates
    def execute
      @semester_dates['begin'] = semester_date('начинаем')
      @semester_dates['end'] = semester_date('заканчиваем')
      length = check_semester_length
      output_semester_length(length)
    end

    private

      # loop input 'end' date, if 'end' < 'begin' and return length ( -> rational)
      def check_semester_length
        while (length = @semester_dates['end'] - @semester_dates['begin']) <= 0
          say("Семестр не может закончиться раньше чем начнется...")
          @semester_dates['end'] = semester_date('заканчиваем')
        end
        length
      end

      # input date, loop input (str -> date)
      def semester_date(action)
        str_date = ask("Когда #{action} учиться? (в формате ГГГГ-ММ-ДД)")
        convert_to_date(str_date)
      rescue ArgumentError
        say("Введен неправильный формат даты.")
        retry
      end

      # calculate and output semester length
      def output_semester_length(length)
        length_month = (length / DAYS_IN_MONTH).to_i
        length_day = (length % DAYS_IN_MONTH).to_i
        say("Понял, на все про все у нас #{length_month} месяцев и #{length_day} дней")
      end

  end
end