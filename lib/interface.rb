# frozen_string_literal: true

module Interface
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
