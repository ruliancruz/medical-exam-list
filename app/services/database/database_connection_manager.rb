require 'pg'
require 'connection_pool'

class DatabaseConnectionManager
  class << self
    def use_connection
      pool.with do |connection|
        connection.exec('BEGIN')
        yield connection if block_given?
        connection.exec('COMMIT')
      rescue StandardError => e
        connection.exec('ROLLBACK')
        raise e
      end
    end

    def pool
      @pool ||= generate_connection_pool
    end

    def reset_pool
      shutdown_pool
      @pool = generate_connection_pool
    end

    def shutdown_pool
      return unless @pool

      @pool.shutdown(&:close)
      @pool = nil
    end

    private

    def generate_connection_pool
      ConnectionPool.new(
        size: ENV.fetch('DB_POOL_SIZE', 5).to_i,
        timeout: ENV.fetch('DB_TIMEOUT', 5).to_i
      ) do
        connect
      end
    end

    def connect
      PG.connect(
        dbname: ENV.fetch('POSTGRES_DB', nil),
        user: ENV.fetch('POSTGRES_USER', nil),
        password: ENV.fetch('POSTGRES_PASSWORD', nil),
        host: ENV.fetch('POSTGRES_HOST', nil),
        port: ENV.fetch('POSTGRES_PORT', nil)
      )
    end
  end
end
