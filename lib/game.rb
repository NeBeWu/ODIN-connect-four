# frozen_string_literal: true

require_relative 'grid'
require_relative 'player'
require_relative 'interface'

class Game
  include Interface

  def initialize
    @grid = Grid.new
    @players = []
    @turn = 0
  end

  def play
    start
    alternate_turns
    finish
  end

  def start
    starting_message
    start_players
  end

  def start_players
    2.times do |number|
      @players << start_player(number + 1)
    end

    @players[1].insert_token(fetch_token(2)) until distinct_tokens?
  end

  def alternate_turns
    until @grid.end?
      play_turn
      @turn += 1
    end
  end

  def play_turn; end

  def finish; end

  private

  def start_player(number)
    name = fetch_name(number)
    token = fetch_token(number)

    Player.new(name, token, number)
  end

  def distinct_tokens?
    @players[0].token != @players[1].token
  end
end
