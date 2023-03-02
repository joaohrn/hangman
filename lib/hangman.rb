module AvailableWords
  WORDS = File.readlines('google-10000-english-no-swears.txt')
end

class Computer
  include AvailableWords
  def choose_word()
    AvailableWords::WORDS[rand(10000)]
  end
end