# сбрасывает для пользователя все данные

module Telegram::Bot::Commands
  class Reset < Base

    # erase all inputed data
    def execute
      @subjects, @semester_dates = {}, {}
      say("Упс... Я все забыл =)")
    end

  end
end