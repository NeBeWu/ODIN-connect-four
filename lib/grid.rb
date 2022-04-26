# frozen_string_literal: true

class Grid
  def initialize
    @columns = Array.new(7) { Array.new(6, ' ') }
  end

  def insert_token(column, token)
    index = @columns[column].rindex(' ')

    @columns[column][index] = token if index

    index
  end

  def full?
    @columns.all? { |column| column.first != ' ' }
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
end
