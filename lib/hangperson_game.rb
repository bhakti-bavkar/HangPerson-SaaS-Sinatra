class HangpersonGame

  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word,guesses='',wrong_guesses='')
    @word = word
    @guesses = guesses
    @wrong_guesses = wrong_guesses
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
  
  def guess(char)
    raise ArgumentError if (/\W|[0-9]|[_]/).match(char) or char == '' or char.nil?
    char = char.downcase
    return false if (@guesses.include?char or @wrong_guesses.include? char)
    (@word.include? char) ? @guesses << char : @wrong_guesses << char
  end
  
  def check_win_or_lose
    all_letters_found = true
    (@word.size).times {|i| all_letters_found = false unless @guesses.include? @word[i] }
    #total_attempts = @guesses.size + @wrong_guesses.size
    return :win  if all_letters_found == true and @wrong_guesses.size <= 7
    return :play if all_letters_found == false and @wrong_guesses.size < 7
    return :lose if all_letters_found == false and @wrong_guesses.size >= 7
  end
  
  def word_with_guesses
    guessed_word = ''
    (@word.size).times { guessed_word << '-' }
    (@guesses.size).times do |i|
      index_found = 0
      while index_found < @word.size do
        index_found = @word.index(@guesses[i],index_found)
        if index_found.nil?
          break
        else
          guessed_word[index_found] = @guesses[i] 
          index_found += 1
        end
      end
    end
    guessed_word
  end

end
