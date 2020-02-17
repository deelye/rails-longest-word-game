require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    # @start_time = Time.new.to_f.round(0)
  end

  def score
    # @end_time = Time.new.to_f.round(0)
    @word = params[:word]
    @letters = params[:letters].split("")

    #create hash of attempt
    word_hash = Hash.new(0)
    @word.upcase.each_char { |char| word_hash[char] += 1 }

    # create hash of grid
    letters_hash = Hash.new(0)
    @letters.each { |char| letters_hash[char] += 1 }

    # check word validity
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    reader = open(url).read
    dictionary = JSON.parse(reader)

    # check attempt vs grid by iterating over attempt and comparing to grid
    word_hash.each do |letter, frequency|
      # if value of attempt[key] is > grid[key]
      if frequency > letters_hash[letter]
        @score = "Sorry but TEST can't be built out of #{@letters}"
      elsif dictionary["found"] == false
        @score = "Sorry but #{@word} does not seem to be a valid English word"
      else
        @score = "CONGRATULATIONS! #{@word} is a valid English word!"
      end
    end
  end
end
