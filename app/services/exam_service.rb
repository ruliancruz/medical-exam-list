require './app/services/database/database_connection_manager'
require './app/services/request_mapper'

ALL_EXAMS_SQL = './database/scripts/select_all_exams.sql'.freeze
REQUEST_BY_TOKEN_SQL = './database/scripts/select_request_by_token.sql'.freeze

class ExamService
  class << self
    def all_as_json
      rows = []

      DatabaseConnectionManager.use_connection do |connection|
        rows = connection.exec File.read ALL_EXAMS_SQL
      end

      requests = RequestMapper.map_requests rows
      requests.values.to_json
    end

    def find_by_token(token)
      result = nil

      DatabaseConnectionManager.use_connection do |connection|
        request_script = File.read REQUEST_BY_TOKEN_SQL
        result = connection.exec_params request_script, [token]
      end

      return token_not_found_message token if result.ntuples.zero?

      request = RequestMapper.build_full_request result.first
      result.each { |row| RequestMapper.add_exam_to_request request, row }
      request.to_json
    end

    private

    def token_not_found_message(token)
      { error: "No exam with token #{token} found" }.to_json
    end
  end
end
