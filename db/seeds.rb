require 'csv'
require 'date'
require 'time'

# Raw Data Paths
sites_path=File.join(Rails.root, "raw_data", "sites.txt")
crimes_path=File.join(Rails.root, "raw_data", "crime_csv_all_years.csv")

# Control vars
seed_date = true
seed_time = true
seed_offence = true
seed_site = true
seed_crime = true

# Seed Date Dimension
if seed_date
  puts "Seeding Date Dimension..."
  start_date = Date.new(2000,1,1)
  end_date = Date.new(2019,12,31)
  dates = (start_date..end_date)
  dates_to_seed = []
  dates.each do |date|
    year = date.year
    month = date.month
    weekday = date.cwday
    day = date.day
    fulldate = Date.new(year, month, day).to_s
    dates_to_seed.push({fulldate: fulldate, year: year, month: month, weekday: weekday, day: day, created_at: Time.now, updated_at: Time.now})
  end
  DateD.insert_all(dates_to_seed)
end

# Seed Time Dimension
if seed_time
  puts "Seeding Time Dimension..."
  hours = (0..23).to_a
  minutes = (0..59).to_a
  hour_s = ""
  minute_s = ""
  times_to_seed = []
  hours.each do |hour|
    if hour < 10
      hour_s = "0#{hour}"
    else
      hour_s= hour
    end
    minutes.each do |minute|
      if minute < 10
        minute_s = "0#{minute}"
      else
        minute_s = minute
      end
      times_to_seed.push({fulltime: "#{hour_s}:#{minute_s}:00", hour: hour, minute: minute, created_at: Time.now, updated_at: Time.now})
    end
  end
  TimeD.insert_all(times_to_seed)
end

# Seed Offence Dimension
if seed_offence
  puts "Seeding Offence Dimension..."
  offences_to_seed = [
    {name: "Break and Enter Commercial", description: "Breaking and entering into a commercial property with intent to commit an offence", created_at: Time.now, updated_at: Time.now},
    {name: "Break and Enter Residential/Other", description: "Breaking and entering into a dwelling/house/apartment/garage with intent to commit an offence", created_at: Time.now, updated_at: Time.now},
    {name: "Homicide", description: "A person, directly or indirectly, by any means, causes the death of another person.", created_at: Time.now, updated_at: Time.now},
    {name: "Mischief", description: "A person commits mischief that willfully causes malicious destruction, damage, or defacement of property. This also includes any public mischief towards another person.", created_at: Time.now, updated_at: Time.now},
    {name: "Offence Against a Person", description: "An attack on a person causing harm that may include usage of a weapon.", created_at: Time.now, updated_at: Time.now},
    {name: "Other Theft", description: "Theft of property that includes personal items (purse, wallet, cellphone, laptop, etc.), bicycle, etc.", created_at: Time.now, updated_at: Time.now},
    {name: "Theft from Vehicle", description: "Theft of property from a vehicle", created_at: Time.now, updated_at: Time.now},
    {name: "Theft of Bicycle", description: "Theft of a bicycle", created_at: Time.now, updated_at: Time.now},
    {name: "Theft of Vehicle", description: "Theft of a vehicle, motorcycle, or any motor vehicle", created_at: Time.now, updated_at: Time.now},
    {name: "Vehicle Collision or Pedestrian Struck (with Fatality)", description: "Includes primarily pedestrian or cyclist struck and killed by a vehicle. It also includes vehicle to vehicle fatal accidents, however these incidents are fewer in number when compared to the overall data set.", created_at: Time.now, updated_at: Time.now},
    {name: "Vehicle Collision or Pedestrian Struck (with Injury)", description: "Includes all categories of vehicle involved accidents with injuries. This includes pedestrian and cyclist involved incidents with injuries.", created_at: Time.now, updated_at: Time.now}
  ]
  Offence.insert_all(offences_to_seed)
end

# Seed Site Dimension
if seed_site
  puts "Seeding Site Dimension..."
  sites_to_seed = []
  File.open(sites_path).each do |line|
    neighbourhood, block = line.split("---")
    sites_to_seed.push({neighbourhood: neighbourhood, block: block.chop, created_at: Time.now, updated_at: Time.now})
  end
  Site.insert_all(sites_to_seed)
end

# Seed Crime Facts
if seed_crime
  puts "Seeding Crimes Facts..."
  initial_date = Date.new(2000,1,1)
  offences = Offence.all
  offences_hash = {}
  offences.each do |o|
    offences_hash[o.name] = o.id
  end
  sites = Site.all
  sites_hash = {}
  sites.each do |s|
    key = s.neighbourhood + "---" + s.block
    sites_hash[key] = s.id
  end
  crimes_to_seed = []
  CSV.foreach(crimes_path, :headers => true, :encoding => 'UTF-8') do |row|
    # TYPE,YEAR,MONTH,DAY,HOUR,MINUTE,HUNDRED_BLOCK,NEIGHBOURHOOD,X,Y
    year = row['YEAR'].to_i
    month = row['MONTH'].to_i
    day = row['DAY'].to_i
    hour = row['HOUR'].to_i
    minute = row['MINUTE'].to_i
    offence_name = row['TYPE'].to_s
    neighbourhood = row['NEIGHBOURHOOD'].to_s
    block = row['HUNDRED_BLOCK'].to_s
    if year < 2019
      # Date Dimension
      crime_date = Date.new(year, month, day)
      date_id = (crime_date - initial_date).to_i + 1
      # Time Dimension
      time_id = hour * 60 + minute + 1
      # Offence Dimension
      offence_id = offences_hash[offence_name]
      # Site Dimension
      key = neighbourhood + "---" + block
      site_id = sites_hash[key]
      crimes_to_seed.push({date_d_id: date_id, time_d_id: time_id, offence_id: offence_id, site_id: site_id, created_at: Time.now, updated_at: Time.now})
    end
  end
  crimes_to_seed.each_slice(50000) do |cts|
    Crime.insert_all(cts)
  end
end
