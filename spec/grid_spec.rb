# frozen_string_literal: true

require_relative '../lib/grid'

# rubocop: disable Metrics/BlockLength

RSpec.describe Grid do
  subject(:grid) { described_class.new }
  let(:columns) { grid.instance_variable_get(:@columns) }

  describe '#insert_token' do
    let(:column) { 3 }
    let(:token) { 'X' }

    context 'when the chosen column is empty' do
      it 'adds a token in the first avaible slot' do
        starting_value = [' ', ' ', ' ', ' ', ' ', ' ']
        ending_value = [' ', ' ', ' ', ' ', ' ', token]

        expect { grid.insert_token(column, token) }
          .to change { columns[column] }
          .from(starting_value).to(ending_value)
      end

      it 'returns the index it was inserted' do
        method_return = grid.insert_token(column, token)
        inserted_index = 5

        expect(method_return).to be(inserted_index)
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
        starting_value = [' ', ' ', 'O', 'X', 'X', 'O']
        ending_value = [' ', token, 'O', 'X', 'X', 'O']

        expect { grid.insert_token(column, token) }
          .to change { columns[column] }
          .from(starting_value).to(ending_value)
      end

      it 'returns the index it was inserted' do
        method_return = grid.insert_token(column, token)
        inserted_index = 1

        expect(method_return).to be(inserted_index)
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
        method_return = grid.insert_token(column, token)

        expect(method_return).to be_nil
      end
    end
  end

  describe '#free_columns' do
    before do
      grid.instance_variable_set(:@columns, [[' ', ' ', ' ', ' ', ' ', ' '],
                                             %w[X X O O O X],
                                             [' ', ' ', ' ', 'O', 'X', 'O'],
                                             %w[X X O X X O],
                                             [' ', ' ', ' ', 'X', 'O', 'X'],
                                             [' ', ' ', ' ', ' ', 'O', 'X'],
                                             [' ', ' ', ' ', ' ', ' ', ' ']])
    end

    it 'returns grid avaible columns' do
      result = [0, 2, 4, 5, 6]

      expect(grid.free_columns).to eq(result)
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

  describe '#vertically_connected?' do
    let(:column) { 3 }
    let(:index) { 2 }

    context 'when @last_slot is too low' do
      before do
        index = 3
        grid.instance_variable_set(:@columns, [%w[X X O O O X],
                                               %w[X O O X O X],
                                               %w[O X X O O O],
                                               %w[O O O X X X],
                                               %w[O X X X O O],
                                               %w[X O X O O X],
                                               %w[X O X O X X]])
        grid.instance_variable_set(:@last_slot, [column, index])
      end

      it 'returns false' do
        expect(grid).to_not be_vertically_connected
      end
    end

    context 'when there is no vertical connection' do
      before do
        grid.instance_variable_set(:@columns, [%w[X X O O O X],
                                               %w[X O O X O X],
                                               %w[O X X O O O],
                                               %w[O X O X X O],
                                               %w[O X X X O O],
                                               %w[X O X O O X],
                                               %w[X O X O X X]])
        grid.instance_variable_set(:@last_slot, [column, index])
      end

      it 'returns false' do
        expect(grid).to_not be_vertically_connected
      end
    end

    context 'when there is a vertical connection' do
      before do
        grid.instance_variable_set(:@columns, [%w[X X O O O X],
                                               %w[X O O X O X],
                                               %w[O X X O O O],
                                               %w[O X O O O O],
                                               %w[O X X X O O],
                                               %w[X O X O O X],
                                               %w[X O X O X X]])
        grid.instance_variable_set(:@last_slot, [column, index])
        grid.instance_variable_set(:@last_token, 'O')
      end

      it 'returns true' do
        expect(grid).to be_vertically_connected
      end
    end
  end

  describe '#horizontally_connected?' do
    let(:column) { 3 }
    let(:index) { 2 }

    context 'when there is no horizontal connection' do
      before do
        grid.instance_variable_set(:@columns, [%w[X X O O O X],
                                               %w[X O O X O X],
                                               %w[O X X O O O],
                                               %w[O X O X X O],
                                               %w[O X X X O O],
                                               %w[X O X O O X],
                                               %w[X O X O X X]])
        grid.instance_variable_set(:@last_slot, [column, index])
      end

      it 'returns false' do
        expect(grid).to_not be_horizontally_connected
      end
    end

    context 'when there is an horizontal connection' do
      before do
        grid.instance_variable_set(:@columns, [%w[X X O O O X],
                                               %w[X O O X O X],
                                               %w[O X O O O O],
                                               %w[O X O X X O],
                                               %w[O X X X O O],
                                               %w[X O X O O X],
                                               %w[X O X O X X]])
        grid.instance_variable_set(:@last_slot, [column, index])
        grid.instance_variable_set(:@last_token, 'O')
      end

      it 'returns true' do
        expect(grid).to be_horizontally_connected
      end
    end
  end

  describe '#diagonally_connected?' do
    let(:column) { 3 }
    let(:index) { 2 }

    context 'when there is no diagonal connection' do
      before do
        grid.instance_variable_set(:@columns, [%w[X X O O O X],
                                               %w[X O O X O X],
                                               %w[O X X O O O],
                                               %w[O X O X X O],
                                               %w[O X X X O O],
                                               %w[X O X O O X],
                                               %w[X O X O X X]])
        grid.instance_variable_set(:@last_slot, [column, index])
      end

      it 'returns false' do
        expect(grid).to_not be_diagonally_connected
      end
    end

    context 'when there is a diagonal connection' do
      before do
        grid.instance_variable_set(:@columns, [%w[X X O O O X],
                                               %w[X O O X O X],
                                               %w[O X O O O O],
                                               %w[O X X X X O],
                                               %w[O X X X O O],
                                               %w[X O X X O X],
                                               %w[X O X O X X]])
        grid.instance_variable_set(:@last_slot, [column, index])
        grid.instance_variable_set(:@last_token, 'X')
      end

      it 'returns true' do
        expect(grid).to be_diagonally_connected
      end
    end
  end

  describe '#winner?' do
    context 'when there is no connection' do
      before do
        allow(grid).to receive(:vertically_connected?).and_return(false)
        allow(grid).to receive(:horizontally_connected?).and_return(false)
        allow(grid).to receive(:diagonally_connected?).and_return(false)
      end

      it 'returns false' do
        expect(grid).to_not be_winner
      end
    end

    context 'when there is a vertical connection' do
      before do
        allow(grid).to receive(:vertically_connected?).and_return(true)
        allow(grid).to receive(:horizontally_connected?).and_return(false)
        allow(grid).to receive(:diagonally_connected?).and_return(false)
      end

      it 'returns true' do
        expect(grid).to be_winner
      end
    end

    context 'when there is an horizontal connection' do
      before do
        allow(grid).to receive(:vertically_connected?).and_return(false)
        allow(grid).to receive(:horizontally_connected?).and_return(true)
        allow(grid).to receive(:diagonally_connected?).and_return(false)
      end

      it 'returns true' do
        expect(grid).to be_winner
      end
    end

    context 'when there is a diagonal connection' do
      before do
        allow(grid).to receive(:vertically_connected?).and_return(false)
        allow(grid).to receive(:horizontally_connected?).and_return(false)
        allow(grid).to receive(:diagonally_connected?).and_return(true)
      end

      it 'returns true' do
        expect(grid).to be_winner
      end
    end
  end

  describe '#end?' do
    context 'when there is no winner and grid is not full' do
      before do
        allow(grid).to receive(:winner?).and_return(false)
        allow(grid).to receive(:full?).and_return(false)
      end

      it 'returns false' do
        expect(grid).to_not be_end
      end
    end

    context 'when there is a winner and grid is not full' do
      before do
        allow(grid).to receive(:winner?).and_return(true)
        allow(grid).to receive(:full?).and_return(false)
      end

      it 'returns true' do
        expect(grid).to be_end
      end
    end

    context 'when there is no winner and grid is full' do
      before do
        allow(grid).to receive(:winner?).and_return(false)
        allow(grid).to receive(:full?).and_return(true)
      end

      it 'returns true' do
        expect(grid).to be_end
      end
    end

    context 'when there is a winner and grid is full' do
      before do
        allow(grid).to receive(:winner?).and_return(true)
        allow(grid).to receive(:full?).and_return(true)
      end

      it 'returns true' do
        expect(grid).to be_end
      end
    end
  end
end

# rubocop: enable Metrics/BlockLength
