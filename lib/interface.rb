# frozen_string_literal: true

module Interface
  def fetch_input(message, error_message, validation, *validation_args)
    puts message
    input = gets.chomp

    until send(validation, input, *validation_args)
      puts error_message
      input = gets.chomp
    end

    input
  end

  def fetch_name(number)
    fetch_input(
      "Please, enter your name player #{number}.",
      'Wrong input! Please enter 1 to 10 word characters.',
      :validate_name
    )
  end

  def fetch_token(number, unavaiable_tokens)
    fetch_input(
      "Please, enter your token player #{number}.",
      "Wrong input! Please enter a non-numeric word character
       not included in #{unavaiable_tokens}.",
      :validate_token,
      unavaiable_tokens
    )
  end

  def fetch_move(name, columns)
    fetch_input(
      "It is your turn #{name}, choose a column please.",
      "Wrong input! Please enter a number contained in #{columns}.",
      :validate_move,
      columns
    )
  end

  def validate_name(name)
    name.match?(/^\w{1,10}$/)
  end

  def validate_token(token, unavaiable_tokens)
    token.match?(/^[a-zA-Z]$/) && !unavaiable_tokens.include?(token)
  end

  def validate_move(move, columns)
    possible_columns = columns.map(&:to_s)

    possible_columns.include?(move)
  end

  def starting_message
    "Let's play connect-four!\n".each_char do |char|
      sleep(0.05)
      print char
    end
  end

  def ending_message(result)
    if result
      puts("Congratulations #{result.name}, you won!")
    else
      puts('It is a draw!')
    end
  end
end
