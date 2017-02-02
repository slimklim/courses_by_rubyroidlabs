require_relative("lib/game_life.rb")
require 'rack'

class LifeWeb

  def initialize
    @space_life = GameLife.new()
  end

  def call(env)
    request = Rack::Request.new(env)
    response = []
    if request.GET["step"] == "next"
      @space_life.step()
    elsif request.GET["step"] == "start"
      @space_life = GameLife.new()
    end
    if @space_life
      response << "<pre>#{@space_life.space.join("<br>")}</pre>"
      response << "<p><a href='#{"?step=next"}'>next step</a></p>"
    end
    response << "<p><a href='#{"?step=start"}'>start game</a></p>"
    [200, {"Content-Type" => "text/html"}, response]
  end

end

life = LifeWeb.new
Rack::Handler::WEBrick.run life