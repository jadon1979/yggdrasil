require 'csv'
# Truncate both of the nodes and birds table.  
# Populate the nodes table using via csv file.
#
# Sample CSV Data: 
#   id,parent_id 
#   125,130 
#   130, 
#   282030,125 
#   4430546,125 
#   5497637,4430546 
#
# Example:
# CSV_FILE='./nodes.csv' rails db:populate_from_csv
#

namespace :db do
  desc "Truncate the tables and repopulate the data"
  task populate_from_csv: [:environment] do
    puts "Truncatng tables..."

    ActiveRecord::Base.connection.truncate_tables(*[ :nodes, :birds ])    

    puts "Opening CSV File..."

    rows = []
    CSV.foreach(ENV['CSV_FILE'], headers: true) do |row| 
      rows << row.to_h.transform_keys({ 'id' => 'node_id' })
    end 

    puts "Importing #{rows.count} Node Records..."

    Node.insert_all(rows)

    puts "Import Complete."
  end
end