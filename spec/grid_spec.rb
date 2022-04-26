# frozen_string_literal: true

require_relative '../lib/grid'

# rubocop: disable Metrics/BlockLength

RSpec.describe Grid do
  subject(:grid) { described_class.new }
  let(:columns) { grid.instance_variable_get(:@columns) }

  describe '#show' do
  end

  describe '#insert_token' do
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
    context 'when the grid is not full' do
      it 'returns false' do
        expect(grid).to_not be_full
      end
    end

    context 'when the grid is full' do
      before do
        grid.instance_variable_set(:@columns, [%w[X X O O O X],
                                               %w[X O O O X X],
                                               %w[O O X X O O],
                                               %w[O X O X X O],
                                               %w[O X X X O O],
                                               %w[X O X O O X],
                                               %w[X O O X X X]])
      end

      it 'returns true' do
        expect(grid).to be_full
      end
    end
  end

  describe '#winner?' do
  end

  describe '#end?' do
  end
end

# rubocop: enable Metrics/BlockLength
