# frozen_string_literal: true

require_relative 'interfaces'

class Player
  include Interfaces
  include Interfaces::PlayerInterface

  attr_reader :name, :token, :number

  def initialize(name = nil, token = nil)
    name.nil? ? fetch_name : @name = name
    token.nil? ? fetch_token : @token = token
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
