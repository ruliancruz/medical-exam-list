require './app/services/csv_service.rb'

describe 'CsvService' do
  describe '#read_csv' do
    it 'successfully' do
      output = CSVService.read_csv('./spec/fixtures/data.csv')

      expect(output).to eq File.read('./spec/fixtures/data.json')
    end
  end
end
