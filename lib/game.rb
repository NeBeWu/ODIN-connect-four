# frozen_string_literal: true

require_relative 'grid'
require_relative 'player'
require_relative 'interface'

class Game
  include Interface

  def initialize
    @grid = Grid.new
    @players = []
    @turn = 1
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
      unavaiable_tokens = @players.map(&:token)
      name = fetch_name(number + 1)
      token = fetch_token(number + 1, unavaiable_tokens)

      @players << Player.new(name, token, number)
    end
  end

  def alternate_turns
    until @grid.end?
      play_turn
      @turn += 1
    end
  end

  def play_turn
    fetch_move(@players[@turn / 2].number, @grid.free_columns)
  end

  def finish; end
end
