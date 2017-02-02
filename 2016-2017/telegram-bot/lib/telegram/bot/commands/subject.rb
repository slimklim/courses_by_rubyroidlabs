# добавляет предмет и количество лабораторных работ по нему

module Telegram::Bot::Commands
  class Subject < Base

    # input @subjects
    def execute
      subject_name = ask("Какой предмет учим?")
      labs_quantity = ask("Сколько лаб надо сдать?")
      labs_quantity = check_input_number(labs_quantity)
      @subjects[subject_name] = (1..labs_quantity).to_a
      say("ОК")
    end

  end
end

