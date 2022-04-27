# frozen_string_literal: true

require_relative '../lib/player'

RSpec.describe Player do
  subject(:player) { described_class.new('Rudolf', 'X', '1') }

  describe '#insert_name' do
    it 'changes @name' do
      starting_name = 'Rudolf'
      ending_name = 'Alice'

      expect { player.insert_name(ending_name) }.to change { player.name }
        .from(starting_name).to(ending_name)
    end
  end

  describe '#insert_token' do
    it 'changes @token' do
      starting_token = 'X'
      ending_token = 'O'

      expect { player.insert_token(ending_token) }.to change { player.token }
        .from(starting_token).to(ending_token)
    end
  end

  describe '#insert_number' do
    it 'changes @number' do
      starting_number = '1'
      ending_number = '0'

      expect { player.insert_number(ending_number) }.to change { player.number }
        .from(starting_number).to(ending_number)
    end
  end
end
