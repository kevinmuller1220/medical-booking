task :import_google_calendar_events => :environment do
  # require 'signet/oauth_2/client'
  doctors = DoctorUser.joins(:identities).where("identities.provider='google_oauth2'")
  doctors.each_with_index do |doctor, index|
    doctor.import_from_google_calendar
  end
end