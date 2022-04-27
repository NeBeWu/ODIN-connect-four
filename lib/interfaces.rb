# frozen_string_literal: true

module Interfaces
  def fetch_input(message, error_message, validation)
    puts message
    input = gets.chomp

    until send(validation, input)
      puts error_message
      input = gets.chomp
    end

    input
  end

  module GridInterface
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

  module PlayerInterface
    def validate_name(name)
      name.match?(/^\w{1,10}$/)
    end

    def validate_token(token)
      token.match?(/^[a-zA-Z]$/)
    end

    def fetch_name
      input = fetch_input(
        'Please, enter your name player 1.',
        'Wrong input! Please enter 1 to 10 word characters.',
        :validate_name
      )

      insert_name(input)
    end

    def fetch_token
      input = fetch_input(
        'Please, enter your token player 1.',
        'Wrong input! Please enter a non-numeric word character.',
        :validate_token
      )

      insert_token(input)
    end
  end
end
