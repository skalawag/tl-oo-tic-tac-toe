class Board
  attr_accessor :cells, :board

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

  def to_s
    return self.board
  end
end

class Player
end

class HumanPlayer
end

class BotPlayer
end

class Game
end
