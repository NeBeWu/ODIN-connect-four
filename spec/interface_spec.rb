# frozen_string_literal: true

require_relative '../lib/interface'

# rubocop: disable Metrics/BlockLength

RSpec.describe Interface do
  subject(:dummy_class) { Class.new.extend(described_class) }
  let(:number) { 1 }
  let(:name) { 'Jordan' }

  describe '#fetch_input' do
    let(:message) { 'Message' }
    let(:error_message) { 'Error message' }
    let(:validation) { :validate }
    let(:extra_args) { [0, true, nil, 'A'] }
    let(:input) { 'Input' }

    context 'when entering input correctly' do
      before do
        allow(dummy_class).to receive(:puts)

        allow(dummy_class).to receive(:gets).and_return(input)
        allow(dummy_class).to receive(:send).with(validation, input,
                                                  *extra_args).and_return(true)
      end

      it 'puts message once' do
        expect(dummy_class).to receive(:puts).with(message).once
        dummy_class.fetch_input(message, error_message, validation, *extra_args)
      end

      it 'does not puts error message' do
        expect(dummy_class).to_not receive(:puts).with(error_message)
        dummy_class.fetch_input(message, error_message, validation, *extra_args)
      end

      it 'returns the last input' do
        expect(dummy_class.fetch_input(message, error_message, validation,
                                       *extra_args)).to eq(input)
      end
    end

    context 'when entering input correctly in the second try' do
      before do
        allow(dummy_class).to receive(:puts)

        wrong_input = '1'
        allow(dummy_class).to receive(:gets).and_return(wrong_input, input)
        allow(dummy_class).to receive(:send).with(validation, wrong_input,
                                                  *extra_args).and_return(false)
        allow(dummy_class).to receive(:send).with(validation, input,
                                                  *extra_args).and_return(true)
      end

      it 'puts message once' do
        expect(dummy_class).to receive(:puts).with(message).once
        dummy_class.fetch_input(message, error_message, validation, *extra_args)
      end

      it 'puts error message once' do
        expect(dummy_class).to receive(:puts).with(error_message).once
        dummy_class.fetch_input(message, error_message, validation, *extra_args)
      end

      it 'returns the last input' do
        expect(dummy_class.fetch_input(message, error_message, validation,
                                       *extra_args))
          .to eq(input)
      end
    end

    context 'when entering input correctly in the fifth try' do
      before do
        allow(dummy_class).to receive(:puts)

        wrong_input1 = '1'
        wrong_input2 = '2'
        wrong_input3 = '3'
        wrong_input4 = '4'
        allow(dummy_class).to receive(:gets)
          .and_return(wrong_input1, wrong_input2, wrong_input3, wrong_input4,
                      input)
        allow(dummy_class).to receive(:send).with(validation, wrong_input1,
                                                  *extra_args).and_return(false)
        allow(dummy_class).to receive(:send).with(validation, wrong_input2,
                                                  *extra_args).and_return(false)
        allow(dummy_class).to receive(:send).with(validation, wrong_input3,
                                                  *extra_args).and_return(false)
        allow(dummy_class).to receive(:send).with(validation, wrong_input4,
                                                  *extra_args).and_return(false)
        allow(dummy_class).to receive(:send).with(validation, input,
                                                  *extra_args).and_return(true)
      end

      it 'puts message once' do
        expect(dummy_class).to receive(:puts).with(message).once
        dummy_class.fetch_input(message, error_message, validation, *extra_args)
      end

      it 'puts error message four times' do
        expect(dummy_class).to receive(:puts).with(error_message)
                                             .exactly(4).times
        dummy_class.fetch_input(message, error_message, validation, *extra_args)
      end

      it 'returns the last input' do
        expect(dummy_class.fetch_input(message, error_message, validation,
                                       *extra_args)).to eq(input)
      end
    end
  end

  describe '#validate_name' do
    context 'when name has less than 1 or more than 10 characters' do
      it 'returns false for less than 1 characters' do
        name = ''
        result = dummy_class.validate_name(name)

        expect(result).to be false
      end

      it 'returns false for more than 10 characters' do
        name = 'asdfghjklop'
        result = dummy_class.validate_name(name)

        expect(result).to be false
      end
    end

    context 'when name is between 1 and 10 characters' do
      it 'returns true for letters' do
        name = 'Loki'
        result = dummy_class.validate_name(name)

        expect(result).to be true
      end

      it 'returns true for numbers' do
        name = '148675'
        result = dummy_class.validate_name(name)

        expect(result).to be true
      end

      it 'returns true for underscore' do
        name = '_'
        result = dummy_class.validate_name(name)

        expect(result).to be true
      end

      it 'returns false for no word characters' do
        name = '!'
        result = dummy_class.validate_name(name)

        expect(result).to be false
      end
    end
  end

  describe '#validate_token' do
    context 'when token has less than 1 or more than 1 characters' do
      it 'returns false for less than 1 characters' do
        token = ''
        unavailable_tokens = []
        result = dummy_class.validate_token(token, unavailable_tokens)

        expect(result).to be false
      end

      it 'returns false for more than 1 characters' do
        token = 'ap'
        unavailable_tokens = []
        result = dummy_class.validate_token(token, unavailable_tokens)

        expect(result).to be false
      end
    end

    context 'when name has 1 character' do
      it 'returns true for letters' do
        token = 'H'
        unavailable_tokens = []
        result = dummy_class.validate_token(token, unavailable_tokens)

        expect(result).to be true
      end

      it 'returns false for numbers' do
        token = '4'
        unavailable_tokens = []
        result = dummy_class.validate_token(token, unavailable_tokens)

        expect(result).to be false
      end

      it 'returns false for underscore' do
        token = '_'
        unavailable_tokens = []
        result = dummy_class.validate_token(token, unavailable_tokens)

        expect(result).to be false
      end

      it 'returns false for no word characters' do
        token = '!'
        unavailable_tokens = []
        result = dummy_class.validate_token(token, unavailable_tokens)

        expect(result).to be false
      end
    end

    context 'when there are unavailable tokens' do
      it 'returns true for available tokens' do
        token = 'H'
        unavailable_tokens = %w[X O A]
        result = dummy_class.validate_token(token, unavailable_tokens)

        expect(result).to be true
      end

      it 'returns false for unavailable tokens' do
        token = 'O'
        unavailable_tokens = %w[X O A]
        result = dummy_class.validate_token(token, unavailable_tokens)

        expect(result).to be false
      end
    end
  end

  describe '#validate_move' do
    it 'returns false for non-number characters' do
      move = ''
      columns = [0, 1, 2, 3, 4, 5, 6]
      result = dummy_class.validate_move(move, columns)

      expect(result).to be false
    end

    it 'returns false for numbers not between 0 and 6' do
      move = '7'
      columns = [0, 1, 2, 3, 4, 5, 6]
      result = dummy_class.validate_move(move, columns)

      expect(result).to be false
    end

    it 'returns false for not available columns' do
      move = '2'
      columns = [0, 1, 3, 4, 5, 6]
      result = dummy_class.validate_move(move, columns)

      expect(result).to be false
    end

    it 'returns true for available columns' do
      move = '1'
      columns = [1, 6]
      result = dummy_class.validate_move(move, columns)

      expect(result).to be true
    end
  end

  describe '#fetch_name' do
    let(:message) { "Please, enter your name player #{number}." }
    let(:error_message) { 'Wrong input! Please enter 1 to 10 word characters.' }
    let(:validation) { :validate_name }
    let(:input) { 'Name' }

    before do
      allow(dummy_class).to receive(:fetch_input).and_return(input)
    end

    it 'fetches input' do
      expect(dummy_class).to receive(:fetch_input).with(message, error_message,
                                                        validation)
      dummy_class.fetch_name(number)
    end
  end

  describe '#fetch_token' do
    let(:message) { "Please, enter your token player #{number}." }
    let(:error_message) do
      "Wrong input! Please enter a non-numeric word character
       not included in #{unavailable_tokens}."
    end
    let(:validation) { :validate_token }
    let(:unavailable_tokens) { %w[X T D A] }
    let(:input) { 'Token' }

    before do
      allow(dummy_class).to receive(:fetch_input).and_return(input)
    end

    it 'fetches input' do
      expect(dummy_class).to receive(:fetch_input)
        .with(message, error_message, validation, unavailable_tokens)
      dummy_class.fetch_token(number, unavailable_tokens)
    end
  end

  describe '#fetch_move' do
    let(:message) { "It is your turn #{name}, choose a column please." }
    let(:error_message) do
      "Wrong input! Please enter a number contained in #{columns}."
    end
    let(:validation) { :validate_move }
    let(:columns) { %w[0 1 3 5] }
    let(:input) { '3' }

    before do
      allow(dummy_class).to receive(:fetch_input).and_return(input)
    end

    it 'fetches input' do
      expect(dummy_class).to receive(:fetch_input)
        .with(message, error_message, validation, columns)
      dummy_class.fetch_move(name, columns)
    end
  end

  describe '#ending_message' do
    context 'when the game results in a player winning' do
      let(:result) { instance_double('Player', name: 'Carl') }
      let(:congratulation) { "Congratulations #{result.name}, you won!" }

      it 'congratulates the player' do
        expect(dummy_class).to receive(:puts).with(congratulation)
        dummy_class.ending_message(result)
      end
    end

    context 'when the game results in no one winning' do
      let(:result) { nil }
      let(:draw) { 'It is a draw!' }

      it 'calls a draw' do
        expect(dummy_class).to receive(:puts).with(draw)
        dummy_class.ending_message(result)
      end
    end
  end
end

# rubocop: enable Metrics/BlockLength
