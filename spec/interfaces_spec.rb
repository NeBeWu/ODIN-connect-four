# frozen_string_literal: true

require_relative '../lib/interface'
require_relative '../lib/player'

# rubocop: disable Metrics/BlockLength

RSpec.describe Interface do
  subject(:dummy_class) { Class.new.extend(described_class) }

  describe '#fetch_input' do
    let(:message) { 'Message' }
    let(:error_message) { 'Error message' }
    let(:validation) { :validate }
    let(:input) { 'Input' }

    context 'when entering input correctly' do
      before do
        allow(dummy_class).to receive(:puts)

        allow(dummy_class).to receive(:gets).and_return(input)
        allow(dummy_class).to receive(:send).with(validation, input)
                                            .and_return(true)
      end

      it 'puts message once' do
        expect(dummy_class).to receive(:puts).with(message).once
        dummy_class.fetch_input(message, error_message, validation)
      end

      it 'does not puts error message' do
        expect(dummy_class).to_not receive(:puts).with(error_message)
        dummy_class.fetch_input(message, error_message, validation)
      end

      it 'returns the last input' do
        expect(dummy_class.fetch_input(message, error_message, validation))
          .to eq(input)
      end
    end

    context 'when entering input correctly in the second try' do
      before do
        allow(dummy_class).to receive(:puts)

        wrong_input = '1'
        allow(dummy_class).to receive(:gets).and_return(wrong_input, input)
        allow(dummy_class).to receive(:send).with(validation, wrong_input)
                                            .and_return(false)
        allow(dummy_class).to receive(:send).with(validation, input)
                                            .and_return(true)
      end

      it 'puts message once' do
        expect(dummy_class).to receive(:puts).with(message).once
        dummy_class.fetch_input(message, error_message, validation)
      end

      it 'puts error message once' do
        expect(dummy_class).to receive(:puts).with(error_message).once
        dummy_class.fetch_input(message, error_message, validation)
      end

      it 'returns the last input' do
        expect(dummy_class.fetch_input(message, error_message, validation))
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
        allow(dummy_class).to receive(:send).with(validation, wrong_input1)
                                            .and_return(false)
        allow(dummy_class).to receive(:send).with(validation, wrong_input2)
                                            .and_return(false)
        allow(dummy_class).to receive(:send).with(validation, wrong_input3)
                                            .and_return(false)
        allow(dummy_class).to receive(:send).with(validation, wrong_input4)
                                            .and_return(false)
        allow(dummy_class).to receive(:send).with(validation, input)
                                            .and_return(true)
      end

      it 'puts message once' do
        expect(dummy_class).to receive(:puts).with(message).once
        dummy_class.fetch_input(message, error_message, validation)
      end

      it 'puts error message four times' do
        expect(dummy_class).to receive(:puts).with(error_message)
                                             .exactly(4).times
        dummy_class.fetch_input(message, error_message, validation)
      end

      it 'returns the last input' do
        expect(dummy_class.fetch_input(message, error_message, validation))
          .to eq(input)
      end
    end
  end
end

RSpec.describe Interface::Player do
  subject(:player) { Player.new('John', 'J') }

  describe '#validate_name' do
    context 'when name has less than 1 or more than 10 characters' do
      it 'returns false for less than 1 characters' do
        name = ''
        result = player.validate_name(name)

        expect(result).to be false
      end

      it 'returns false for more than 10 characters' do
        name = 'asdfghjklop'
        result = player.validate_name(name)

        expect(result).to be false
      end
    end

    context 'when name is between 1 and 10 characters' do
      it 'returns true for letters' do
        name = 'Loki'
        result = player.validate_name(name)

        expect(result).to be true
      end

      it 'returns true for numbers' do
        name = '148675'
        result = player.validate_name(name)

        expect(result).to be true
      end

      it 'returns true for underscore' do
        name = '_'
        result = player.validate_name(name)

        expect(result).to be true
      end

      it 'returns false for no word characters' do
        name = '!'
        result = player.validate_name(name)

        expect(result).to be false
      end
    end
  end

  describe '#validate_token' do
    context 'when token has less than 1 or more than 1 characters' do
      it 'returns false for less than 1 characters' do
        token = ''
        result = player.validate_token(token)

        expect(result).to be false
      end

      it 'returns false for more than 1 characters' do
        token = 'ap'
        result = player.validate_token(token)

        expect(result).to be false
      end
    end

    context 'when name has 1 character' do
      it 'returns true for letters' do
        token = 'H'
        result = player.validate_token(token)

        expect(result).to be true
      end

      it 'returns false for numbers' do
        token = '4'
        result = player.validate_token(token)

        expect(result).to be false
      end

      it 'returns false for underscore' do
        token = '_'
        result = player.validate_token(token)

        expect(result).to be false
      end

      it 'returns false for no word characters' do
        token = '!'
        result = player.validate_token(token)

        expect(result).to be false
      end
    end
  end

  describe '#fetch_name' do
    let(:message) { 'Please, enter your name player 1.' }
    let(:error_message) { 'Wrong input! Please enter 1 to 10 word characters.' }
    let(:validation) { :validate_name }
    let(:input) { 'Name' }

    before do
      allow(player).to receive(:fetch_input).and_return(input)
    end

    it 'fetches input' do
      expect(player).to receive(:fetch_input).with(message, error_message,
                                                   validation)
      player.fetch_name
    end

    it 'inserts name' do
      expect(player).to receive(:insert_name).with(input)
      player.fetch_name
    end
  end

  describe '#fetch_token' do
    let(:message) { 'Please, enter your token player 1.' }
    let(:error_message) do
      'Wrong input! Please enter a non-numeric word character.'
    end
    let(:validation) { :validate_token }
    let(:input) { 'Token' }

    before do
      allow(player).to receive(:fetch_input).and_return(input)
    end

    it 'fetches input' do
      expect(player).to receive(:fetch_input).with(message, error_message,
                                                   validation)
      player.fetch_token
    end

    it 'inserts token' do
      expect(player).to receive(:insert_token).with(input)
      player.fetch_token
    end
  end
end

# rubocop: enable Metrics/BlockLength
