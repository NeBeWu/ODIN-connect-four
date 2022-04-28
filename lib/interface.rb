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

  def validate_name(name)
    name.match?(/^\w{1,10}$/)
  end

  def validate_token(token, unavaiable_tokens)
    token.match?(/^[a-zA-Z]$/) && !unavaiable_tokens.include?(token)
  end
end
