require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    # return if request.referer == request.url.chop.chop
    @x = request.referer
    @y = request.url.chop.chop

    @letters = params[:letters] ? params[:letters].split : []

    # return if request.refer == request.url.chop.chop && params[:letters].empty?

    return unless @letters.length < 9
    # return unless @letters.length > 0


    @letters << %w[A E I O U].sample if params[:vowel] # && @letters.length < 9 #
    @letters << %w[B C D F G H J K L M N P Q R S T V W X Y Z].sample if params[:consonant] # && @letters.length < 9 #
    # return if session[:letters] == @letters
    # session[:letters] = @letters
  end

  def score
    return unless params[:word]

    if valid?(params[:letters].upcase.split, params[:word].upcase)
      @result = word_check(params[:word].upcase)
      session[:score] = @result['found'] ? generate_score : "#{params[:word].upcase} is not a word."
    else
      session[:score] = "Invalid word - #{params[:word].upcase} can't be made from #{params[:letters].upcase}."
    end
  end

  private

  def valid?(letters, word)
    word.chars.each do |letter|
      @word_valid = false
      break unless letters.index(letter)

      letters.delete_at(letters.index(letter))
      @word_valid = true
    end
    @word_valid
  end

  def word_check(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = URI.open(url).read
    JSON.parse(user_serialized)
  end

  def generate_score
    "#{@result['word'].upcase} is worth #{@result['length']} points"
  end
end

# require 'json'
# require 'open-uri'

# class GamesController < ApplicationController
#   def new
#     @letters = []
#     9.times { @letters << Array('A'..'Z').sample }
#   end

#   def score
#     @word = params[:word].upcase
#     @letters = params[:letters].upcase

#     if valid?(@letters.split, @word)
#       @result = word_check(@word)
#       @score = @result['found'] ? generate_score : "#{@word} is not a word."
#     else
#       @score = "Invalid word - #{@word} can't be made from #{@letters}."
#     end
#   end

#   private

#   def valid?(letters, word)
#     word.chars.each do |letter|
#       @word_valid = false
#       break unless letters.index(letter)

#       letters.delete_at(letters.index(letter))
#       @word_valid = true
#     end
#     @word_valid
#   end

#   def word_check(attempt)
#     url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
#     user_serialized = URI.open(url).read
#     JSON.parse(user_serialized)
#   end

#   def generate_score()
#     "#{@result['word'].upcase} is worth #{@result['length']} points"
#   end
# end
