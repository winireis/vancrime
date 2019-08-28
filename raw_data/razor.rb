require 'csv'
block = Hash.new(0)

CSV.foreach("crime_csv_all_years.csv", :headers => true, :encoding => 'UTF-8') do |row|
  #TYPE,YEAR,MONTH,DAY,HOUR,MINUTE,HUNDRED_BLOCK,NEIGHBOURHOOD,X,Y
  #year = row['YEAR'].to_i
  #month = row['MONTH'].to_i
  #day = row['DAY'].to_i
  #hour = row['HOUR'].to_i
  #minute = row['MINUTE'].to_i
  #offence_name = row['TYPE'].to_s
  #neighbourhood = row['NEIGHBOURHOOD'].to_s
  key = row['NEIGHBOURHOOD'].to_s + "---" + row['HUNDRED_BLOCK'].to_s
  block[key]+= 1
end

#puts "#{block.length} unique registers"
block.each do |key, value|
  puts "#{key}"
end
