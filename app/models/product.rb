require 'csv'
require 'roo'


class Product < ApplicationRecord

	def self.import(file)
		spreadsheet = open_spreadsheet(file)
    	header = spreadsheet.row(1)
    	(2..spreadsheet.last_row).each do |i|
      		row = Hash[[header, spreadsheet.row(i)].transpose]
      		product = find_by_id(row["id"]) || new
      		product.attributes = row.to_hash.slice(*row.to_hash.keys)
      		product.save!
    	end
	end	

	def self.open_spreadsheet(file)
    	case File.extname(file.original_filename)
    		when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
  			when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
  			when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    	else raise "Unknown file type: #{file.original_filename}"
    	end
  	end

	def self.to_csv(options = {})
    	CSV.generate(options) do |csv|
      		csv << column_names
      		all.each do |product|
        		csv << product.attributes.values_at(*column_names)
      		end
    	end
  	end

  	

end
