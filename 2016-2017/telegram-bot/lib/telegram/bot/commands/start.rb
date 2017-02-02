# выводит приветствие и описание всех доступных команд

module Telegram::Bot::Commands
  class Start < Base

    # meeting and output all available commands from @@subjects
    def execute
      say("#{@message.from.first_name}! Привет, салага!")
      say("Вот какие команды я знаю:")
      Base.available_commands.each do |instruction, description|
        say("#{instruction} #{description}")
      end
    end

  end
end