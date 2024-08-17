require 'pg'
require './app/services/database/database_connection_manager'

RSpec.describe DatabaseConnectionManager do
  before { described_class.reset_pool }
  after { described_class.shutdown_pool }

  describe '#use_connection' do
    it 'reuses connections from the pool' do
      connections = []

      2.times do
        described_class.use_connection do |connection|
          connections << connection
        end
      end

      expect(connections.first).to be_a PG::Connection
      expect(connections.uniq.size).to eq 1
    end

    it 'handles concurrent connections safely' do
      threads = Array.new 10 do
        Thread.new do
          described_class.use_connection do |connection|
            expect(connection).to be_an_instance_of PG::Connection
          end
        end
      end

      threads.each(&:join)
    end
  end
end
