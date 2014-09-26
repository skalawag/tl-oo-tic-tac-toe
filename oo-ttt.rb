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
    (1..9).to_a - open_cells()
  end

  def occupied_by(mark)
    self.cell_map.map {|k,v| k if self.board[self.cell_map[k]] == mark}.compact
  end

  def to_s
    return self.board
  end
end

class HumanPlayer
  attr_accessor :name, :moves, :mark

  def initialize(name, mark='X')
    @name = name
    @mark = mark
    @moves = []
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

  def to_s
    return "#{name}"
  end
end

class BotPlayer
  attr_accessor :name, :moves, :mark, :board, :adjacent

  def initialize(name, mark='O', board)
    @name = name
    @mark = mark
    @moves = []
    @board = board
    @adjacent =
      {[1,2] => 3, [2,3] => 1, [4,5] => 6, [5,6] => 4, [7,8] => 9, [8,9] => 7,
      [1,4] => 7, [2,5] => 8, [3,6] => 9, [4,7] => 1, [5,8] => 2, [6,9] => 3,
      [1,5] => 9, [5,9] => 1, [3,5] => 7, [5,7] => 3, [1,7] => 4, [2,8] => 5,
      [3,9] => 6, [1,3] => 2, [4,6] => 5, [7,9] => 8, [1,9] => 5, [3,7] => 5}
  end

  def center_free?
    if self.board.open_cells.include?(5)
      return true
    end
  end

  ## CONSIDER: if i pass the board to these functions as an argument,
  ## i don't have to have the board residing in this class.
  def blocking_move_avail?
    opponent_mark = self.mark == 'X' ? 'O' : 'X'
    closed = self.board.occupied_by(opponent_mark)
    open = self.board.open_cells()
    result = nil
    self.adjacent.each do |k,v|
      if closed.include?(k[0]) && closed.include?(k[1]) && open.include?(v)
        result = v
      end
    end
    result
  end

  def choose(open_cells)
    if center_free?
      self.moves << 5
      return 5
    end
    b = blocking_move_avail?
    if b
      self.moves << b
      return b
    else
      choice = open_cells.sample
      self.moves << choice
      return choice
    end
  end

  def to_s
    return "#{name}"
  end
end

class Game
  attr_accessor :human, :bot, :board

  def initialize()
    data = greet()
    @board = Board.new()
    @human = HumanPlayer.new(data[0], data[1])
    @bot = BotPlayer.new("Bot", data[1] == 'X' ? 'O' : 'X', @board)
    @board = board
  end

  def greet
    puts "Tic-Tac-Toe"
    puts ""
    puts "Your name?"
    name = gets.chomp.capitalize
    puts "Will you play as X or O?"
    mark = gets.chomp
    while mark != 'O' && mark != 'X'
      puts "Eh? Will you play as X or O?"
      mark = gets.chomp.upcase
    puts "Good luck!"
    return name, mark
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
        display_board()
        if run_player(second) == 1
            break
        end
      end
      # catch the last move
      display_board()

      if winner?(self.human)
        puts "#{human.name} has won!"
      elsif winner?(self.bot)
        puts "#{bot.name} has won!"
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

Game.new().run_game
