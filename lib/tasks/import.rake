namespace :import do
  desc "import appointments data into db"
  task :data => :environment do
    require 'csv'

    file = File.join Rails.root, "appt_data.csv"
    csv = CSV.foreach(file, headers: true) do |row|
      Appointment.create!(row.to_hash)
    end
  end  
end