module Telegram::Bot::Commands
  class Base

    # view all *.rb files in folder /commands/ and read first line with comment of class ( -> hash)
    def self.available_commands
      result = {}
      full_filenames = Dir['lib/telegram/bot/commands/*.rb']
      full_filenames.each do |f|
        instruction = File.basename(f)[0...-3] # delete extention '.rb'
        description = File.readlines(f).first
        result["/#{instruction}"] = description unless instruction == 'base'
      end
      result
    end

    def initialize(bot, message)
      @bot, @message = bot, message
    end

    # load object attributes from profile
    def load_profile_chat
      filename = "profiles/#{@message.chat.id}.json"
      data = search_profile(filename)
      load_semester_dates(data)
      load_subjects(data)
    end

    # save profile from object attributes
    def save_profile_chat
      filename = "profiles/#{@message.chat.id}.json"
      data = {'semester_dates' => @semester_dates, 'subjects' => @subjects}
      profile = JSON.generate(data)
      file = File.open(filename, 'w')
      file.write(profile)
      file.close
    end

    private

      # answer to current chat (str -> )
      def say(text)
        @bot.api.sendMessage(chat_id: @message.chat.id, text: text)
      end

      # request to current chat (str -> str)
      def ask(text)
        say(text)
        @bot.listen do |message|
          return message.text
        end
      end

      # (str -> str)
      def button(value)
        "[ #{value} ]"
      end

      # check input string is not number > 0, loop input (str -> num)
      def check_input_number(input_str)
        while input_str.to_i <= 0 do
          input_str = ask("Введи положительное число!")
        end
        input_str.to_i
      end

      # (str -> date or nil)
      def convert_to_date(str_date)
        Date.parse(str_date) if str_date
      end

      # load profile data from file or set empty hash (str -> hash)
      def search_profile(filename)
        if File.exist?(filename)
          file = File.read(filename)
          JSON.parse(file)
        else
          { 'semester_dates' => {}, 'subjects' => {} }
        end
      end

      # load @semester_dates from profile data (hash -> )
      def load_semester_dates(data)
        @semester_dates = {}
        unless data['semester_dates'].empty?
          data['semester_dates'].
            each { |key, value| @semester_dates[key] = convert_to_date(value) }
        end
      end

      # load @subjects from profile data (hash -> )
      def load_subjects(data)
        @subjects = data['subjects']
      end

  end
end