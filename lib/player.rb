# frozen_string_literal: true

class Player
  attr_reader :name, :token, :number

  def initialize(name, token, number)
    @name = name
    @token = token
    @number = number
  end

  def insert_name(name)
    @name = name
  end

  def insert_token(token)
    @token = token
  end

  def insert_number(number)
    @number = number
  end
end
