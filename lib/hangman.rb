module AvailableWords
  WORDS = File.readlines('google-10000-english-no-swears.txt')
end

class Computer
  include AvailableWords
  def choose_word()
    AvailableWords::WORDS[rand(10000)].chomp
  end
end

class Human
  def get_input()
    loop do
      puts 'Type your guess:'
      choice = gets.chomp
      if choice.length == 1
        return choice
      else
        puts 'invalid input try again'
      end  
    end

  end
end

class Game
  def initialize
    @human_player = Human.new
    @computer_player = Computer.new
  end

  def play_game()
    chosen_word = @computer_player.choose_word.split ''
    hidden_word = chosen_word.map { '_' }
    wrong_guesses = []
    number_of_attempts = 8
    while number_of_attempts > 0
      puts "#{hidden_word}"
      puts "You have #{number_of_attempts} attempts left."
      puts "Wrong guesses: #{wrong_guesses}"
      choice = @human_player.get_input.downcase
      if chosen_word.include?(choice)
        chosen_word.each_with_index do |char, ind|
          hidden_word[ind] = choice if char == choice 
        end
      elsif wrong_guesses.include?(choice) || hidden_word.include?(choice)
        puts 'Already guessed this one.'
      else
        wrong_guesses << choice
        number_of_attempts -= 1
      end
      if hidden_word.join('') == chosen_word.join('')
        puts "You win it was #{chosen_word.join ''}"
        return
      end
    end
    puts "you lose, it was #{chosen_word.join ''}"
  end
end

game = Game.new
game.play_game
