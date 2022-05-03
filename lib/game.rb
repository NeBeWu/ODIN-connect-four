# frozen_string_literal: true

require_relative 'grid'
require_relative 'player'
require_relative 'interface'

class Game
  include Interface

  def initialize(players = [], turn = 0)
    @grid = Grid.new
    @players = players
    @turn = turn
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
    turn_player = @players.at(@turn % 2)

    move = fetch_move(turn_player.name, @grid.free_columns)

    @grid.insert_token(move, turn_player.token)
  end

  def finish
    ending_message(game_result)
  end

  def game_result
    result = @grid.winner? ? @grid.last_token : false
    @players.select { |player| player.token == result }.first
  end
end
