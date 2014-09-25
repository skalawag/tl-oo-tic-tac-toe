require 'pry'

class Board
  attr_accessor :cells, :board
  attr_reader :cell_map

  def initialize
    @board =
      "         |         |          \n" <<
      "         |         |          \n" <<
      "         |         |          \n" <<
      "---------+---------+----------\n" <<
      "         |         |          \n" <<
      "         |         |          \n" <<
      "         |         |          \n" <<
      "---------+---------+----------\n" <<
      "         |         |          \n" <<
      "         |         |          \n" <<
      "         |         |          "

    @cell_map =
      {1 => 35, 2 => 45, 3 => 55, 4 => 159, 5 => 169,
      6 => 179, 7 => 283, 8 => 293, 9 => 303}
  end

  def place_mark(cell, mark)
    if cell < 1 || 9 < cell
      return "Illegal Cell"
    else
      self.board[self.cell_map[cell]] = mark
    end
  end

  def clear_board
    self.cell_map.values.each { |v| self.board[v] = " " }
  end

  def open_cells
    self.cell_map.map { |k,v | k if self.board[v] == ' ' }.compact
  end

  def closed_cells
    (1..9).to_a - closed_cells()
  end

  def to_s
    return self.board
  end
end

class Player
  attr_accessor :name, :moves, :mark

  def initialize(name, mark='X')
    @name = name
    @mark = mark
    @moves = []
  end

  def to_s
    return "#{name}"
  end
end

class HumanPlayer < Player

  def initialize(name, mark='X')
    super(name, mark)
  end

  def choose
    puts "Choose a cell: (1-9)"
    choice = gets.chomp.to_i
    while choice < 1 && choice > 9
      puts "Eh? Choose a cell: (1-9)"
      choice = gets.chomp.to_i
    end
    self.moves << choice
    choice
  end
end

class BotPlayer < Player
  def initialize(name, mark='O')
    super(name, mark)
  end

  def choose(open_cells)
    choice = open_cells.sample
    self.moves << choice
    choice
  end
end

class Game
  attr_accessor :human, :bot, :board

  def initialize(human, bot, board)
    @human = human
    @bot = bot
    @board = board
  end

  def winner?(player=nil)
    winners =
      [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [3,5,7], [1,5,9]]
    winners.each do |w|
      if player.nil?
        test1 = w - self.human.moves
        test2 = w - self.bot.moves
        if test1.empty? || test2.empty?
          return true
        end
      else
        test = w - player.moves
        if test.empty?
          return true
        end
      end
    end
    return false
  end

  def run_player(player)
    if self.board.open_cells.empty?
      return 1
    else
      if player.name == self.bot.name
        self.board.place_mark(player.choose(self.board.open_cells()), player.mark)
      else
        self.board.place_mark(player.choose(), player.mark)
      end
      if winner?()
        return 1
      end
    end
  end

  def reset
    self.board.clear_board
    self.human.moves = []
    self.bot.moves = []
  end

  def display_board
    system 'clear'
    puts self.board
  end

  def run_game
    rand(2) == 0 ? first = self.human : first = self.bot
    first == self.human ? second = self.bot : second = self.human

    while true
      # inner loop handles one game
      while true
        display_board()
        if run_player(first) == 1
            break
        end
        if run_player(second) == 1
            break
        end
      end
      # catch the last move
      display_board()

      if winner?(self.human)
        puts "#{human.name} has won!}"
      elsif winner?(self.bot)
        puts "#{bot.name} has won!}"
      else
        puts "Tie!"
      end

      puts "Would you like to play another? (y/n)"
      if gets.chomp != 'y'
        break
      else
        reset()
      end
    end
  end
end

Game.new(HumanPlayer.new("Mark", "X"),
         BotPlayer.new("Bot", "O"),
         Board.new()).run_game
