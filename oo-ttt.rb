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
    if cell < 1 || 9 < cell || mark != 'X' || mark != 'O'
      return "Illegal Cell"
    else
      self.board[self.cell_map[cell]] = mark
    end
  end

  def clear_board
    self.cell_map.values.each { |v| self.board[v] = " " }
  end

  def open_cells
    self.cell_map.values.map { |k,v | k if self.board[v] == ' ' }
  end

  def closed_cells
    (1..9).to_a - closed_cells()
  end

  def to_s
    return self.board
  end
end

class Player
  attr_accessor :name, :moves

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

  def winner?(player)
    winners =
      [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [3,5,7], [1,5,9]]
    winners.each do |w|
      if w - player.moves == []
        return true
      end
    end
  end

  def run
    while true
      puts self.board
      break
    end
  end
end

g = Game.new(HumanPlayer.new("Mark", "X"), BotPlayer.new("Cruncher", "O"), Board.new())
g.run()
