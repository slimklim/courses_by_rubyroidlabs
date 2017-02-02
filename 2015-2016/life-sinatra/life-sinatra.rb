require_relative "./lib/game_life.rb"
require 'sinatra'

use Rack::Session::Pool, :expire_after => 2592000
set :public_folder, File.dirname(__FILE__) + '/static'

LIVE = '*'
DEAD = '-'

get '/' do
  @space = session['space']
  @cols = session['cols']
  @rows = session['rows']
  slim :index
end

post '/set_size' do
  session['cols'], session['rows'] = params[:cols].to_i, params[:rows].to_i
  redirect to('/clear_space')
end

get '/randomize' do
  session['space'] = GameLife.random_space(session['space'], [DEAD,LIVE])
  redirect to('/')
end

get '/next_step' do
  session['space'] = GameLife.step(session['space'], session['cols'], session['rows'])
  redirect to('/')
end

post '/set_space' do
  session['cols'].times do |i|
    session['rows'].times do |j|
      session['space'][i][j] = params["#{i}x#{j}".to_sym] ? LIVE : DEAD
    end
  end
  redirect to('/')
end

get '/clear_space' do
  session['space'] = Array.new(session['cols'], Array.new(session['rows']))
  session['space'] = GameLife.random_space(session['space'], [DEAD,DEAD])
  redirect to('/')
end

post '/load_file' do
  session['space'], session['cols'], session['rows'] =
    GameLife.load_file(params[:file][:tempfile]) if params[:file]
  redirect to('/')
end


