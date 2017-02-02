# выводит твой список лаб, которые тебе предстоит сдать

require 'date'

module Telegram::Bot::Commands
  class Status < Base

    # output status all labs of all subjects
    def execute
      return if dates_unavailable? || subjects_unavailable?
      say("К этому времени у тебя должно быть сдано (приблизительно):")
      labs_calculate(method_calc("approximately"))
      say("А если быть точнее:")
      labs_calculate(method_calc("concretely"))
      labs_calculate(method_calc("complited"))
      labs_calculate(method_calc("not complited"))
      say("Не откладывай на завтра то, на что еще есть время сегодня!")
    end

    private

      # processing data about labs at each subject (proc -> )
      def labs_calculate(method)
        @subjects.each do |subject, labs|
          gone = summ_gone_labs(labs.size)
          method.call(labs, gone, subject)
        end
      end

      # select method for answer about labs at subject (str -> proc )
      def method_calc(selected)
        case selected
          when "approximately"
            Proc.new do |labs, gone, subject|
              say("#{subject} - #{gone} из #{labs.size}")
            end
          when "concretely"
            Proc.new do |labs, gone, subject|
              not_completed_labs = labs.compact.map  { |lab| lab if lab <= gone }
              say("#{subject} - лабы #{not_completed_labs.compact.to_s[1...-1]}")
            end
          when "complited"
            Proc.new do |labs, gone|
              complited = summ_labs() { |labs| labs[0...gone].count(nil)}
              say("Ты сдал #{complited}.")
            end
          when "not complited"
            Proc.new do |labs, gone|
              total = summ_labs() { |labs| labs[0...gone].size}
              remaining = summ_labs() { |labs| labs[0...gone].compact.size}
              say("Тебе осталось сдать #{remaining} лаб из #{total}. Не грусти, лето уже скоро.")
            end
        end
      end

      # check exist data of semester dates ( -> bool)
      def dates_unavailable?
        unless @semester_dates.size == 2
          say("Отсутствуют данные о начале и конце семестра.")
          return true
        end
        false
      end

      def subjects_unavailable?
        if @subjects.empty?
          say("Отсутствуют данные о предметах.")
          return true
        end
        false
      end

      # calculate approximate number labs, that were to be complete on today (num -> num)
      def summ_gone_labs(labs_quantity)
        k = (Date.today - @semester_dates['begin']).to_f /
                  (@semester_dates['end'] - @semester_dates['begin']).to_f
        (labs_quantity * k).to_i
      end

      # calculate summary labs by yield (block -> num)
      def summ_labs
        result = 0
        @subjects.each do |subject, labs|
          result += yield(labs)
        end
        result
      end

  end
end
