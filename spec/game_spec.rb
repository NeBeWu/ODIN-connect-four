# frozen_string_literal: true

require_relative '../lib/game'

# rubocop: disable Metrics/BlockLength

RSpec.describe Game do
  subject(:game) { described_class.new }
  let(:players) { game.instance_variable_get(:@players) }
  let(:grid) { game.instance_variable_get(:@grid) }

  describe '#start_players' do
    let(:player1) { Player.new('Claire', 'C', 0) }
    let(:player2) { Player.new('Teresa', 'T', 1) }

    before do
      allow(game).to receive(:fetch_name).and_return('Claire', 'Teresa')
      allow(game).to receive(:fetch_token).and_return('C', 'T')
    end

    it 'adds 2 players to @players with given attributes' do
      game.start_players
      expect(game.instance_variable_get(:@players)).to eq([player1, player2])
    end
  end

  describe '#alternate_turns' do
    context 'while game does not end' do
      let(:turn_times) { 10 }

      before do
        game.instance_variable_set(:@players, [
                                     Player.new('Roger', 'R', 0),
                                     Player.new('Harry', 'H', 1)
                                   ])

        response_array = Array.new(turn_times, false) << true
        allow(grid).to receive(:end?).exactly(turn_times + 1).times
                                     .and_return(*response_array)
        allow(game).to receive(:play_turn)
      end

      it 'plays a turn' do
        expect(game).to receive(:play_turn).exactly(turn_times).times
        game.alternate_turns
      end

      it 'updates @turn' do
        expect { game.alternate_turns }
          .to change { game.instance_variable_get(:@turn) }
          .from(1).to(turn_times + 1)
      end
    end
  end

  describe '#play_turn' do
  end
end

# rubocop: enable Metrics/BlockLength
