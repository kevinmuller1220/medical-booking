# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#creating predefine Roles
first_names = %w(Brian Jade Nicole Minato Bred Tony)
last_names = %w(Dre Jade Raimondo Kawasaki William Bred)
bio_text = '<p>After qualifying as a specialist in 1960, Kevorkian bounced around the country
    from hospital to hospital, publishing more than 30 professional journal articles and
    booklets about his philosophy on death, before setting up his own clinic near Detroit,
    Michigan. The business ultimately failed, and Kevorkian headed to California to commute
    between two part-time pathology jobs in Long Beach. These jobs also ended quickly when
    Kevorkian quit in another dispute with a chief pathologist; Jack claimed that his career
    was doomed by physicians who feared his radical ideas.</p>
    <p>Kevorkian "retired" to devote his time to a film project about Handel\'s Messiah as
    well as research for his reinvigorated death-row campaign. By 1970, however, Kevorkian
    was still jobless and had also lost his fiancee; he broke off the relationship after
    finding his bride-to-be lacking in self-discipline. By 1982, Kevorkian was living alone,
    occasionally sleeping in his car, living off of canned food and social security.</p>'

specialities_services = [
  {
    name: 'Wrinkle Reduction',
    services: [
      'Botox',
      'Dysport',
      'Xeomin'
    ]
  },
  {
    name: 'Dermal Fillers',
    services: [
      'Restylane',
      'Juvaderm',
      'Voluma',
      'Silk',
      'Restylane Lyft',
      'Bellatero',
      'Radiesse',
      'Sculptra',
      'Artefill',
      'Bellafill ',
      'Fat'
    ]
  },
  {
    name: 'Skin Treatments',
    services: [
      'Laser brown spot removal (IPL)',
      'Laser resurfacing (CO2-Fraxel)',
      'Laser resurfacing (Erbium)',
      'Laser tightening (Profound)',
      'Laser hair removal',
      'Chemical Peels - Glycolic Acid',
      'Chemical Peels - TCA Peel',
      'Obagi Skin care',
      'Skin Medica  Skin care',
      'Micro-needling',
    ]
  },
  {
    name: 'Non surgical fat reduction',
    services: [
      'Coolsculpting',
      'Liposonix',
      'Zerona',
      'Trusculpt',
      'Kybella'
    ]
  },
  {
    name: 'Hair restoration',
    services: [
      'Neograft',
      'Blue light treatment',
      'Artmis',
      'ARTAS',
    ]
  },
  {
    name: 'Cellulite and Vein Treatment',
    services: [
      'Cellfina',
      'Cellulaze'
    ]
  }
]

puts '-- Adding predefined specialities and services'
specialities_services.each do |speciality|
  s = Speciality.new
    s.name = speciality[:name]
  s.save!
  speciality[:services].each do |service|
    sv = Service.new
    sv.name = service
    sv.speciality_id = s.id
    sv.save!
  end
end
puts '-- Done'

# Add a admin user
puts '-- Adding a admin user with email: admin@example.com and password: password'
admin = AdminUser.new
  admin.first_name = 'admin'
  admin.last_name = 'user'
  admin.email = 'admin@example.com'
  admin.password = 'password'
  admin.skip_confirmation!
admin.save!
puts '-- Done'

# Add test doctors
puts '-- Adding test doctors'
Speciality.all.each_with_index do |speciality, index|
  d = DoctorUser.new
    d.first_name = first_names[index]
    d.last_name = last_names[index]
    d.email = "test_doctor#{index}@gmail.com"
    d.phone = "9939992930"
    d.address = "Lombard Street"
    d.city = "San Francisco"
    d.state = "CA"
    d.zipcode = "94133"
    d.country = "US"
    d.password = "password"
    d.skip_confirmation!
    d.build_doctor_info(
      speciality_id: speciality.id,
      days: [1,2,3,4,5],
      hours_from: '8:00',
      hours_to: '17:00',
      website: "http://example.com",
      bio: bio_text,
      feedback_count: 1,
      feedback_score: 5
    )
  d.save!
  puts "\temail: #{d.email}, password: #{d.password}"
end
puts '-- Done'

# Add a test patient
puts "-- Adding a test patient with email: test_patient@gmail.com, password: password"
p = PatientUser.new
  p.first_name = 'Test'
  p.last_name = 'Patient'
  p.email = "test_patient@gmail.com"
  p.phone = "123456789"
  p.address = "Beach Street"
  p.city = "San Francisco"
  p.state = "CA"
  p.zipcode = "94133"
  p.country = "US"
  p.password = "password"
  p.skip_confirmation!
p.save!
puts '-- Done'
