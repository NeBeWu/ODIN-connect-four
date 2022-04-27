# frozen_string_literal: true

module Interface
  def fetch_input(message, error_message, validation)
    puts message
    input = gets.chomp

    until send(validation, input)
      puts error_message
      input = gets.chomp
    end

    input
  end

  def fetch_name(player)
    input = fetch_input(
      "Please, enter your name player #{player.number}.",
      'Wrong input! Please enter 1 to 10 word characters.',
      :validate_name
    )

    player.insert_name(input)
  end

  def fetch_token(player)
    input = fetch_input(
      "Please, enter your token player #{player.number}.",
      'Wrong input! Please enter a non-numeric word character.',
      :validate_token
    )

    player.insert_token(input)
  end

  def validate_name(name)
    name.match?(/^\w{1,10}$/)
  end

  def validate_token(token)
    token.match?(/^[a-zA-Z]$/)
  end
end
