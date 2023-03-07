require 'yaml'
module AvailableWords
  WORDS = File.readlines('google-10000-english-no-swears.txt')
end

class Computer
  include AvailableWords
  def choose_word()
    AvailableWords::WORDS[rand(10_000)].chomp
  end
end

class Human
  def get_input()
    loop do
      puts 'Type your guess:'
      choice = gets.chomp
      if(('a'..'z').include?(choice) || choice == '1')
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

  def new_game
    @chosen_word = @computer_player.choose_word.split ''
    @hidden_word = @chosen_word.map { '_' }
    @wrong_guesses = []
    @number_of_attempts = 8
  end

  def load_game
    save = File.open('saves/save.yml', 'r')
    loaded_game = YAML.load save
    save.close
    @chosen_word = loaded_game[:chosen_word]
    @hidden_word = loaded_game[:hidden_word]
    @wrong_guesses = loaded_game[:wrong_guesses]
    @number_of_attempts = loaded_game[:number_of_attempts]
  end

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open('saves/save.yml', 'w') do |file|
      save_data = {
        chosen_word: @chosen_word,
        hidden_word: @hidden_word,
        wrong_guesses: @wrong_guesses,
        number_of_attempts: @number_of_attempts
      }
      file.puts YAML.dump(save_data)
      break
    end
  end

  def start_game
    puts 'Type 1 to start a new game'
    puts 'Type 2 to load a save'
    choice = gets.chomp
    if choice == '1'
      new_game
      play_game
    elsif choice == '2' && File.exist?('saves/save.yml')
      load_game
      play_game
    end
  end

  def play_game()
    while @number_of_attempts.positive?
      puts @hidden_word.to_s
      puts "You have #{@number_of_attempts} attempts left."
      puts "Wrong guesses: #{@wrong_guesses}"
      puts 'type 1 to save and quit'
      choice = @human_player.get_input.downcase
      if choice == '1'
        save_game
        return nil
      elsif @chosen_word.include?(choice)
        @chosen_word.each_with_index do |char, ind|
          @hidden_word[ind] = choice if char == choice 
        end
      elsif @wrong_guesses.include?(choice) || @hidden_word.include?(choice)
        puts 'Already guessed this one.'
      else
        @wrong_guesses << choice
        @number_of_attempts -= 1
      end
      if @hidden_word.join('') == @chosen_word.join('')
        puts "You win it was #{@chosen_word.join ''}"
        return
      end
    end
    puts "you lose, it was #{@chosen_word.join ''}"
  end
end

game = Game.new
game.start_game
