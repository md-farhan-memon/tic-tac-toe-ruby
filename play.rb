# frozen_string_literal: true

require_relative 'tictactoe/grid.rb'

class Play
  attr_accessor :grid, :positions

  def initialize(grid_size, user_1_type, user_2_type)
    @grid = Grid.new(grid_size)
    @grid.add_user(user_1_type)
    @grid.add_user(user_2_type)
    @positions = generate_positions(grid_size)
  end

  def begin!
    counter = 0
    @grid.users.shuffle.cycle.each do |user|
      if user.type == 'Computer'
        @grid.make_a_move!(user)
        fix_positions!
        puts "Player #{user.symbol}'s move:\n\n"
      else
        invalid_input = true

        while invalid_input
          display_positions
          print 'Make a move (Enter position number): '
          position = gets.chomp.to_i

          invalid_input = @positions[position].nil?

          if invalid_input
            puts "\nInvalid position entered, please try again..."
          else
            x, y = @positions[position]
            @grid.manual_move!(user, x, y)
            @positions[position] = nil
            puts "Player #{user.symbol}'s move:\n\n"
          end
        end
      end
      @grid.display
      puts '---------------------------------------------------------------'
      counter += 1

      if !(winner = @grid.who_won?).nil?
        puts "'#{winner.symbol}' is the WINNER!!!"
        break
      elsif counter == (@grid.size * @grid.size)
        puts "\nWell, it's a TIE..."
        break
      end
    end
  end

  def display_positions
    positions = @positions.each_slice(@grid.size).map do |row|
      row.map do |pos, value|
        pos = value.nil? ? nil : pos
        pos.to_s.ljust(5)
      end.join('')
    end

    puts positions
  end

  private

  def generate_positions(size)
    positions = {}
    counter = 0
    size.times do |y|
      size.times do |x|
        positions[(counter += 1)] = [x, y]
      end
    end

    positions
  end

  def fix_positions!
    counter = 0
    @grid.size.times do |y|
      @grid.size.times do |x|
        counter += 1
        @positions[counter] = nil unless @grid.board[y][x].nil?
      end
    end
  end
end

print 'What is the grid size you want to play? (Enter number between 1 - 10): '

grid_size = gets.chomp.to_i

if grid_size <= 0 || grid_size > 10
  puts("\nInvalid grid size. Exiting...")
  exit
end

puts "How would you like to play?\n"
puts([
       '1. Human versus Human',
       '2. Human versus Computer',
       '3. Computer versus Computer',
       '4. Exit'
     ])
print "\nEnter your option: "

game_type = gets.chomp.to_i

case game_type
when 1
  play = Play.new(grid_size, 'Human', 'Human')
  play.begin!
when 2
  play = Play.new(grid_size, 'Human', 'Computer')
  play.begin!
when 3
  play = Play.new(grid_size, 'Computer', 'Computer')
  play.begin!
when 4
  puts '#okbye!'
else
  puts "\nInvalid selection for game type. Exiting..."
end

def invalid_method; end

def new_method_only; end
