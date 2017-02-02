require 'pry'


require 'telegram/bot'

Dir["lib/telegram/bot/commands/*.rb"].each { |f| require_relative(f) }

TOKEN = '295472773:AAHWEznOGXkUbdD9a5MHErZOoOOUYtuTx6s'

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    commands = Telegram::Bot::Commands::Base.available_commands
    commands.each do |instruction, description|
      if message.text == instruction
        class_name = instruction[1..-1].capitalize # transform '/example' to Example
        command = eval("Telegram::Bot::Commands::#{class_name}.new(bot, message)")
        command.load_profile_chat
        command.execute
        command.save_profile_chat
      end
    end
  end
end