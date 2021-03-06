# frozen_string_literal: true

require_relative '../lib/game'

# rubocop: disable Metrics/BlockLength

RSpec.describe Game do
  subject(:game) { described_class.new }
  let(:players) { [Player.new('Claire', 'C', 0), Player.new('Teresa', 'T', 1)] }
  let(:grid) { game.instance_variable_get(:@grid) }
  let(:turn) { game.instance_variable_get(:@turn) }

  describe '#start_players' do
    before do
      allow(game).to receive(:fetch_name).and_return(players.at(0).name,
                                                     players.at(1).name)
      allow(game).to receive(:fetch_token).and_return(players.at(0).token,
                                                      players.at(1).token)
    end

    it 'adds 2 players to @players with given attributes' do
      expect { game.start_players }.to change {
        game.instance_variable_get(:@players)
      }
        .from([]).to(players)
    end
  end

  describe '#alternate_turns' do
    let(:turns) { 10 }

    before do
      game.instance_variable_set(:@players, players)
    end

    context 'while game does not end' do
      before do
        response_array = Array.new(turns, false) << true

        allow(grid).to receive(:end?).exactly(turns + 1).times
                                     .and_return(*response_array)
        allow(game).to receive(:play_turn)
      end

      it 'shows the grid' do
        expect(game.instance_variable_get(:@grid)).to receive(:show)
          .exactly(turns).times
        game.alternate_turns
      end

      it 'plays a turn' do
        expect(game).to receive(:play_turn).exactly(turns).times
        game.alternate_turns
      end

      it 'updates @turn' do
        expect { game.alternate_turns }
          .to change { game.instance_variable_get(:@turn) }
          .from(0).to(turns)
      end
    end

    context 'when the game ends' do
      before do
        response_array = Array.new(turns - 2, false)
        3.times { response_array << true }

        allow(grid).to receive(:end?).exactly(turns + 1).times
                                     .and_return(*response_array)
        allow(game).to receive(:play_turn)
      end

      it 'does not show the grid' do
        expect(game.instance_variable_get(:@grid)).to receive(:show)
          .exactly(turns - 2).times
        game.alternate_turns
      end

      it 'does not play a turn' do
        expect(game).to receive(:play_turn).exactly(turns - 2).times
        game.alternate_turns
      end

      it 'does not update @turn' do
        expect { game.alternate_turns }
          .to change { game.instance_variable_get(:@turn) }
          .from(0).to(turns - 2)
      end
    end
  end

  describe '#play_turn' do
    let(:turn_player) { players.at(turn % 2) }
    let(:free_columns) { [0, 1, 3, 4, 5] }
    let(:move) { 4 }

    before do
      game.instance_variable_set(:@players, players)
      game.instance_variable_set(:@turn, 19)

      allow(game.instance_variable_get(:@grid)).to receive(:free_columns)
        .and_return(free_columns)
      allow(game).to receive(:fetch_move).with(turn_player.name,
                                               free_columns)
                                         .and_return(move.to_s)
    end

    it 'fetches the current player move' do
      expect(game).to receive(:fetch_move).with(turn_player.name,
                                                free_columns)
                                          .and_return(move)

      game.play_turn
    end

    it 'updates @grid with the move' do
      expect(game.instance_variable_get(:@grid)).to receive(:insert_token)
        .with(move - 1, turn_player.token)

      game.play_turn
    end
  end

  describe '#finish' do
    let(:result) { nil }

    before do
      allow(game).to receive(:game_result).and_return(result)
    end

    it 'shows grid' do
      expect(game.instance_variable_get(:@grid)).to receive(:show)
      game.finish
    end

    it 'calls ending_message with game_result output' do
      expect(game).to receive(:ending_message).with(result)
      game.finish
    end
  end

  describe '#game_result' do
    before do
      game.instance_variable_set(:@players, players)
    end

    context 'when player 1 wins the game' do
      before do
        allow(game.instance_variable_get(:@grid)).to receive(:winner?)
          .and_return(true)
        allow(game.instance_variable_get(:@grid)).to receive(:last_token)
          .and_return('C')
      end

      it 'returns player 1' do
        expect(game).to receive(:finish).and_return(players.first)

        game.finish
      end
    end

    context 'when player 2 wins the game' do
      before do
        allow(game.instance_variable_get(:@grid)).to receive(:winner?)
          .and_return(true)
        allow(game.instance_variable_get(:@grid)).to receive(:last_token)
          .and_return('T')
      end

      it 'returns player 2' do
        expect(game).to receive(:finish).and_return(players.last)

        game.finish
      end
    end

    context 'when no player wins the game' do
      before do
        allow(game.instance_variable_get(:@grid)).to receive(:winner?)
          .and_return(false)
      end

      it 'returns nil' do
        expect(game).to receive(:finish).and_return(nil)

        game.finish
      end
    end
  end
end

# rubocop: enable Metrics/BlockLength
