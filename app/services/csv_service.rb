require 'csv'

class CsvService
  COLUMN_SEPARATOR = ';'.freeze

  def self.read_csv(file_path)
    rows = CSV.read file_path, col_sep: COLUMN_SEPARATOR
    columns = rows.shift

    rows.map do |row|
      row.each_with_object({}).with_index do |(cell, accumulator), index|
        column = columns[index]
        accumulator[column] = cell
      end
    end
  end
end
