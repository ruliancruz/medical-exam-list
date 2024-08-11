require 'pg'
require './db/database_connection'

describe 'Database Connection' do
  describe '#get_connection' do
    it 'returns a valid PG connection' do
      connection = DatabaseConnector.get_connection

      expect(connection).to be_an_instance_of(PG::Connection)
      expect(connection.status).to eq(PG::CONNECTION_OK)
    ensure
      connection.close if connection
    end
  end
end
