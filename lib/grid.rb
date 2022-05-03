# frozen_string_literal: true

class Grid
  attr_reader :columns, :last_slot, :last_token

  def initialize
    @columns = Array.new(7) { Array.new(6, ' ') }
    @last_slot = [0, 0]
    @last_token = 'O'
  end

  def show
    6.times do |row|
      print "-----------------------------\n"

      @columns.each do |column|
        print "| #{column[row]} "
      end

      print "|\n"
    end

    print "-----------------------------\n"
  end

  def insert_token(column, token)
    row = @columns[column].rindex(' ')

    return unless row

    @columns[column][row] = token
    update_last_move(column, row, token)
  end

  def update_last_move(column, row, token)
    @last_slot = [column, row]
    @last_token = token
  end

  def free_columns
    free_columns = []

    @columns.each_index do |index|
      free_columns << index if @columns[index].first == ' '
    end

    free_columns
  end

  def full?
    @columns.all? { |column| column.first != ' ' }
  end

  def vertically_connected?
    vertical_array(@last_slot) == Array.new(4, @last_token)
  end

  def horizontally_connected?
    horizontal_arrays(@last_slot).any? do |array|
      array == Array.new(4, @last_token)
    end
  end

  def diagonally_connected?
    diagonal_arrays(@last_slot).any? do |array|
      array == Array.new(4, @last_token)
    end
  end

  def winner?
    vertically_connected? || horizontally_connected? || diagonally_connected?
  end

  def end?
    winner? || full?
  end

  private

  # Generates an array with @columns entries starting from slot and following
  # the direction given
  def generate_array(slot, direction)
    array = []

    4.times do
      if (0..7).include?(slot.first) && (0..6).include?(slot.last)
        array << @columns[slot.first][slot.last]
      end

      slot = [slot.first + direction.first, slot.last + direction.last]
    end

    array
  end

  def vertical_array(slot)
    generate_array(slot, [0, 1])
  end

  def horizontal_arrays(slot)
    arrays = []

    4.times do |entry|
      arrays << generate_array([slot.first - entry, slot.last], [1, 0])
    end

    arrays
  end

  def diagonal_arrays(slot)
    arrays = []

    4.times do |entry|
      arrays << generate_array([slot.first - entry, slot.last - entry], [1, 1])
    end

    4.times do |entry|
      arrays << generate_array([slot.first + entry, slot.last - entry], [-1, 1])
    end

    arrays
  end
end
