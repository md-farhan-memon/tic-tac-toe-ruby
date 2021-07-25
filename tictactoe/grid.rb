# frozen_string_literal: true

require_relative 'user.rb'

class Grid
  attr_reader :size, :users, :board, :symbols

  SYMBOLS = %w[X O].freeze

  def initialize(size)
    # Set given size
    @size = size
    # Set empty list of users
    @users = []
    # set all values in the board as nil based on grid size
    @board = size.times.map { Array.new(size, nil) }
    # Creating a copy of SYMBOLS
    @symbols = SYMBOLS.dup
    # Positive Corner coordinates remain the same irrespective of grid size
    @corner_coordinates = [[0, 0], [0, (@size - 1)], [(@size - 1), 0]]
    # Calculate positive top row and bottom coordinates
    @other_coordinates = other_first_row_column_coordinates
    # Removing corner coordinates from remaining coordinates to avoid redundant checks
    @corner_coordinates.each { |cc| @other_coordinates.delete(cc) }
  end

  def add_user(type)
    # Can't add users if all symbols are used up
    return if @symbols.empty?

    # Randomly assigning symbol to a user
    @users << User.new(type, @symbols.delete(@symbols.sample))
  end

  def display
    puts(@board.map { |row| row.map { |symbol| symbol.to_s.ljust(5) }.join('') })
  end

  def make_a_move!(user)
    # Return if it's not a computer move
    return if user.type != 'Computer'

    # Setting default values for making a valid move
    @value_set = false
    @optimistic_coordinates = []
    @current_symbol = user.symbol
    @check_for_win = false

    # Check from the corner coordinates
    corners
    # Check from non-corner coordinates
    non_corners
    # Make an optimistic move - where it's possible to win in next move
    optimistic_assignment
    # Finally, if nothing works out, use the first empty spot
    random_assignment
  end

  def manual_move!(user, x, y)
    # Return if it's not a human move
    return if user.type != 'Human'

    # Return if the spot is not empty
    return unless @board[y][x].nil?

    # Set the current symbol in case of valid user move
    @board[y][x] = user.symbol
  end

  def who_won?
    # Set default values for finding the winning symbol
    @value_won = nil
    @check_for_win = true

    # Check through corners for winning symbol
    corners
    # Check through other coordinates for winning symbol
    non_corners

    if @value_won.nil? # Winning symbol not found
      nil
    else
      # Find the user with winning symbol
      @users.select { |user| user.symbol == @value_won }.first
    end
  end

  private

  attr_writer :size, :users, :board, :symbols

  attr_accessor :value_set, :value_won, :other_coordinates, :corner_coordinates,
                :optimistic_coordinates, :current_x, :current_y, :current_symbol,
                :check_for_win

  # Should proceed in loop only if
  # you are checking for winners and winner not found yet
  # you are not checking for winners and value is not set by computer yet
  def should_proceed?
    ((@check_for_win && @value_won.nil?) || (!@check_for_win && !@value_set))
  end

  # Check corner coordinates for symbol
  def corners
    @corner_coordinates.each do |x, y|
      @current_x = x
      @current_y = y
      if !@board[@current_y][@current_x].nil? && should_proceed?
        check_for_probable_position_from_corner
      end
    end
  end

  # Check non-corner coordinates for symbol
  def non_corners
    @other_coordinates.each do |x, y|
      @current_x = x
      @current_y = y
      if !@board[@current_y][@current_x].nil? && should_proceed?
        check_for_probable_position_from_non_corner
      end
    end
  end

  # You can check for diagonal, row and column completions from corners
  def check_for_probable_position_from_corner
    check_for_diagonals
    check_for_rows
    check_for_columns
  end

  # You can check for only row and column completions from non-corners
  def check_for_probable_position_from_non_corner
    check_for_rows
    check_for_columns
  end

  def check_for_markings(symbols, diff)
    # Return if the spot should not be used for marking
    return unless should_mark_here?(symbols, diff)

    # If the spot is to be used for marking,
    # find the first empty spot and mark it.
    new_x = @current_x
    new_y = @current_y
    (@size - 1).times do
      new_x, new_y = [new_x, new_y].zip(diff).map(&:sum)
      next unless @board[new_y][new_x].nil? && !@value_set

      @board[new_y][new_x] = @current_symbol
      @value_set = true
    end
  end

  def check_for_winning_symbol(symbols)
    # A symbol is said to be winning if
    # All the positions are filled and contains same symbol
    symbols.uniq!
    @value_won = symbols.first if symbols.count == 1 && !symbols.first.nil?
  end

  def check_for_generic(diff)
    return unless should_proceed?

    new_x = @current_x
    new_y = @current_y
    symbols = [@board[new_y][new_x]]

    # Find all symbols in the winning line - diagonal, row or column
    (@size - 1).times do
      new_x, new_y = [new_x, new_y].zip(diff).map(&:sum)
      symbols << @board[new_y][new_x]
    end

    @check_for_win ? check_for_winning_symbol(symbols) : check_for_markings(symbols, diff)
  end

  def check_for_rows
    return unless @current_x.zero?

    # For checking all rows for symbols
    # it should start with x = 0
    # keep incrementing value of x, keeping y as constant
    check_for_generic([1, 0])
  end

  def check_for_columns
    return unless @current_y.zero?

    # For checking all columns for symbols
    # it should start with y = 0
    # keep incrementing value of y, keeping x as constant
    check_for_generic([0, 1])
  end

  def check_for_diagonals
    diff = if @current_x.zero? && @current_y.zero?
             #  Check for primary diagonal starting with origin
             [1, 1]
           elsif @current_x == (@size - 1)
             #  Increasing y coordinate and descreasing x coordinate to find diagonal elements
             [-1, 1]
           else
             #  Increasing x coordinate and descreasing y coordinate to find diagonal elements
             [1, -1]
           end

    check_for_generic(diff)
  end

  # You should mark this position immidiately if
  # you are winning - all elements are your symbols with one spot remaining
  # opponent is winning - all elements are opponent's symbols with one spot remaining
  # In neither scenario, if you are winning in next move i.e. you are 2 moves away from winning,
  # You should keep this coordinates as future reference
  def should_mark_here?(symbols, diff)
    rival_symbol = @current_symbol == 'X' ? 'O' : 'X'

    return true if symbols.count(@current_symbol) == (@size - 1) && symbols.include?(nil) ||
                   symbols.count(rival_symbol) == (@size - 1) && symbols.include?(nil)

    if symbols.count(@current_symbol) == (@size - 2) && symbols.include?(nil)
      mark_optimistic!(diff)
    end

    false
  end

  # Adding the coordinates to a list as it could be winnable position next time
  def mark_optimistic!(diff)
    new_x = @current_x
    new_y = @current_y
    (@size - 1).times do
      new_x, new_y = [new_x, new_y].zip(diff).map(&:sum)
      next unless @board[new_y][new_x].nil?

      @optimistic_coordinates << [new_x, new_y]
      break
    end
  end

  # Use optimistic position so that you can win next time you have chance
  def optimistic_assignment
    return if @value_set || @optimistic_coordinates.empty?

    x, y = @optimistic_coordinates.first
    @board[y][x] = @current_symbol
    @value_set = true
  end

  # Find the first empty spot in sequence and fill it
  def random_assignment
    return if @value_set

    @size.times do |x|
      @size.times do |y|
        if !@value_set && @board[y][x].nil?
          @board[y][x] = @current_symbol
          @value_set = true
        end
      end
    end
  end

  # Generating first row and column coordinates for non-corner elements
  def other_first_row_column_coordinates
    coordinates = []
    @size.times do |x|
      coordinates << [x, 0] unless @corner_coordinates.include?([x, 0])
    end

    @size.times do |y|
      coordinates << [0, y] unless @corner_coordinates.include?([0, y])
    end

    coordinates
  end
end
