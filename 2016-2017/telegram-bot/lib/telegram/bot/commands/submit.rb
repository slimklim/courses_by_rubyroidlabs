# отмечает какие лабы по каким предметам ты сдал

module Telegram::Bot::Commands
  class Submit < Base

    # erase data about one choised lab of choised subject
    def execute
      subject = receive_subject
      lab = receive_lab(subject)
      lab_index = lab - 1
      @subjects[subject][lab_index]  = nil if @subjects[subject].size >= lab
      say("Ок, вычеркиваем...")
    end

    private

      # input subject ( -> str)
      def receive_subject
        subjects = @subjects.keys.
                    map { |subject| button(subject) }.
                    join("\n")
        subject = ask("Что сдавал?\n#{subjects}")
        check_exist_subject(subject)
      end

      # input lab (str -> num)
      def receive_lab(subject)
        labs = @subjects[subject].compact.
                map { |lab| button(lab) }.
                join("\n")
        lab = ask("Какая лаба?\n#{labs}")
        lab = check_input_number(lab)
        check_exist_lab(subject, lab)
      end

      # check exist subject in @subjects, loop input
      def check_exist_subject(subject)
        until @subjects.keys.include?(subject)
          subject = ask("Не знаю о таком предмете. Попробуй ввести еще раз")
        end
        subject
      end

      # check exist lab in @subjects[subject], loop input
      def check_exist_lab(subject, lab)
        until @subjects[subject].include?(lab)
          lab = ask("Нет такой лабы по '#{subject}'. Попробуй ввести еще раз")
        end
        lab
      end
  end
end
