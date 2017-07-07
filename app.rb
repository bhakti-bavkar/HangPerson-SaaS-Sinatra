require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game   = session[:game] || HangpersonGame.new('')
    @result = session[:result] || :new
  end
  
  after do
    session[:game] = @game
    session[:result] = @result
  end
 
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    @result = :new
    erb :new
  end
  
  post '/create' do
    word = params[:word] || HangpersonGame.get_random_word
    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  post '/guess' do
    letter = params[:guess].to_s[0]
    begin
      result = @game.guess(letter)
      flash[:message] = "You have already used that letter." unless result
    rescue
      flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end
  
  get '/show' do
    @result = @game.check_win_or_lose
    #session[:result] = @result 
    case @result
    when :play; erb :show
    when :win ; redirect '/win'
    when :lose; redirect '/lose'
    else ;      redirect '/new'
    end
  end
  
  get '/win' do
    if @result == :win
      erb :win 
    else
      redirect '/show'
    end
  end
  
  get '/lose' do
    if @result == :lose
      erb :lose 
    else
      redirect '/show'
    end 
  end
  
end
