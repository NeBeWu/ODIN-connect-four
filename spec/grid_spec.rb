# frozen_string_literal: true

require_relative '../lib/grid'

# rubocop: disable Metrics/BlockLength

RSpec.describe Grid do
  subject(:grid) { described_class.new }

  describe '#show' do
  end

  describe '#insert_token' do
    let(:columns) { grid.instance_variable_get(:@columns) }
    let(:column) { 3 }
    let(:token) { 'X' }

    context 'when the chosen column is empty' do
      it 'adds a token in the first avaible slot' do
        expect { grid.insert_token(column, token) }.to change { columns[column] }
          .from([' ', ' ', ' ', ' ', ' ', ' '])
          .to([' ', ' ', ' ', ' ', ' ', token])
      end

      it 'returns the index it was inserted' do
        expect(grid.insert_token(column, token)).to be(5)
      end
    end

    context 'when the chosen column is not empty' do
      before do
        grid.instance_variable_set(:@columns, [[' ', ' ', ' ', ' ', ' ', ' '],
                                               [' ', ' ', ' ', ' ', ' ', ' '],
                                               [' ', ' ', ' ', ' ', ' ', ' '],
                                               [' ', ' ', 'O', 'X', 'X', 'O'],
                                               [' ', ' ', ' ', ' ', ' ', ' '],
                                               [' ', ' ', ' ', ' ', ' ', ' '],
                                               [' ', ' ', ' ', ' ', ' ', ' ']])
      end

      it 'adds a token in the first avaible slot' do
        expect { grid.insert_token(column, token) }
          .to change { columns[column] }
          .from([' ', ' ', 'O', 'X', 'X', 'O'])
          .to([' ', token, 'O', 'X', 'X', 'O'])
      end

      it 'returns the index it was inserted' do
        expect(grid.insert_token(column, token)).to be(1)
      end
    end

    context 'when the chosen column is full' do
      before do
        grid.instance_variable_set(:@columns, [[' ', ' ', ' ', ' ', ' ', ' '],
                                               [' ', ' ', ' ', ' ', ' ', ' '],
                                               [' ', ' ', ' ', ' ', ' ', ' '],
                                               %w[X O X X X O],
                                               [' ', ' ', ' ', ' ', ' ', ' '],
                                               [' ', ' ', ' ', ' ', ' ', ' '],
                                               [' ', ' ', ' ', ' ', ' ', ' ']])
      end

      it 'does not add a token to the chosen column' do
        expect { grid.insert_token(column, token) }
          .to_not(change { columns[column] })
      end

      it 'returns nil' do
        expect(grid.insert_token(column, token)).to be_nil
      end
    end
  end

  describe '#full?' do
  end

  describe '#winner?' do
  end

  describe '#end?' do
  end
end

# rubocop: enable Metrics/BlockLength
