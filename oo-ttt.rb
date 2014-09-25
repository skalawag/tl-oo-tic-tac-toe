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
    if cell < 1 || 9 < cell || not mark =~ /X|O/
      return "Illegal Cell"
    else
      self.board[self.cell_map[cell]] = mark
    end
  end

  def clear_board
    self.cell_map.keys.each { |k| self.board[k] = " " }

  def to_s
    return self.board
  end
end

class Player
  attr_accessor :name

  def intialize(name, mark='X')
    @name = name
    @mark = mark
  end

  def to_s
    return "#{name}"
  end
end

class HumanPlayer < Player
  def intialize(name, mark='X')
    super(name, mark)
  end

  def choose
  end
end

class BotPlayer < Player
  def initialize(name, mark='O')
    super(name, mark)
  end

  def choose
  end
end

class Game
  attr_accessor :human, :bot, :board

  def intialize(human, bot, board)
    @human = human
    @bot = bot
    @board = board
  end

  def run
    while true
      break
    end
  end
end
