require 'sidekiq'
require 'tempfile'
require './app/services/csv_importer'

class CSVImportWorker
  include Sidekiq::Worker

  def perform(csv_content)
    Tempfile.create(['data', '.csv']) do |temporary_file|
      temporary_file.write(csv_content)
      temporary_file.rewind
      CSVImporter.import_to_database temporary_file.read
    end
  end
end
