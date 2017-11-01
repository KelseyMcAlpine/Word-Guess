require 'faker'
require 'colorize'

# define class
class  WordGame
  attr_accessor :answer_array, :empty_array, :wrong_guesses, :dead_flower, :answer
  attr_reader :answer

  def initialize
    @answer = ""
    @guess = ""
    @answer_array = []
    @wrong_guesses = []
    @empty_array = []
    @flower = ["(@)", "(@)", "(@)", "(@)", "(@)"]
    @dead_flower = []
  end

  def select_level
    print "Select level [1] CAT NAMES, [2] POKEMON NAMES, or [3] LOTR CHARACTERS "
    level = gets.chomp.downcase

    if level == "1" || level == "cat names"
      @answer = Faker::Cat.name.upcase
    elsif level == "2" || level == "pokemon names"
      @answer = Faker::Pokemon.name.upcase
    elsif level == "3" || level == "lotr characters"
      @answer = Faker::LordOfTheRings.character.upcase
    else
      select_level
    end

    @answer_array = @answer.split("")
    @empty_array = Array.new(@answer_array.length, " _ ")
    run_game
  end

  # gets guess from user
  def run_game
    while @wrong_guesses.length < 5 && @answer_array != @empty_array
      check_input
      evaluate
      display
      run_game
    end
    end_game
  end

  # evaluates whether the user's guess was a valid input
  def check_input
    print "Guess: "
    @guess = gets.chomp.upcase
    until /[A-Z]/.match(@guess) && @guess.length == 1
      puts "Please enter a single letter."
      check_input
    end
    while @wrong_guesses.include?(@guess) || @empty_array.include?(@guess)
      puts "You've already guessed that!"
      check_input
    end
  end

  # makes sure user hasn't already guessed that letter
  # evaluates the user's guess as correct or incorrect
  def evaluate
    if @answer_array.include?(@guess)
      correct
    else
      incorrect
    end
  end

  # displays correct letter
  def correct
    index_array = @answer_array.each_index.select {|index| @answer_array[index] == @guess}

    index_array.each do |index|
      @empty_array[index] = @guess
    end
  end

  # removes a flower for each incorrect answer
  def incorrect
    @wrong_guesses << @guess
    @flower.pop
    @dead_flower << "(@)"
  end

  # displays how many petals are left
  # displays blank spaces and correct letters
  # display wrong guesses
  def display
    print "\n    " + @flower.join("").light_magenta + @dead_flower.join("").light_black.blink
    puts "\n   \,\\,\\,|,/,/,".light_green
    puts "      _\\|/_".light_green
    puts "     |_____|".light_cyan
    puts "      |   |".light_cyan
    puts "      |___|\n\n".light_cyan
    puts "Word: " + @empty_array.join(" ")
    puts "\nWrong Guesses: #{@wrong_guesses.join(" ").white.on_red.blink} \n"
  end

  # tells user whether they won or lost
  # if they lost displays word
  # prompts user to play again
  def end_game
    if @answer_array == @empty_array
      puts "CONGRATULATIONS! You guessed the correct word.".blue.on_light_green.blink
    else
      puts "YOU RAN OUT OF GUESSES. The correct word was #{@answer}."
    end

    print "\nWould you like to play again? (YES/NO): "
    response = gets.chomp.downcase

    if response == "yes" || "y"
      new_game = WordGame.new
      puts new_game.select_level
    else
      puts "GOODBYE!"
      exit
    end
  end
end

# displays title
# starts new game
puts "WELCOME TO OUR WORD GAME"
word = WordGame.new
puts word.select_level
