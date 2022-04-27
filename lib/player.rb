# frozen_string_literal: true

require_relative 'interface'

class Player
  include Interface
  include Interface::Player

  attr_reader :name, :token

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
end
