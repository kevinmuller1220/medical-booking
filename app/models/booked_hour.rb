class BookedHour < ActiveRecord::Base
  belongs_to :doctor_user, class_name: 'DoctorUser', foreign_key: 'doctor_user_id'
  belongs_to :patient_user, class_name: 'PatientUser', foreign_key: 'patient_user_id'

  has_one :review, dependent: :delete, foreign_key: "appointment_id"

  enum status: [ :pending, :imported, :approved, :canceled ]

  def has_feedback?
    self.review.present?
  end

  def approve_appointment!
  	self.approved!

    doctor = self.doctor_user
  	identity = doctor.identities.find_with_provider('google_oauth2')
    return if identity.nil?

    patient = self.patient_user

    client = Signet::OAuth2::Client.new(access_token: identity.token)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client
    event = Google::Apis::CalendarV3::Event.new ({
      summary: self.title,
      location: doctor.full_address,
      description: self.title,
      start: {
        date_time: self.from.iso8601,
        time_zone: Time.zone.name
      },
      end: {
        date_time: self.to.iso8601,
        time_zone: Time.zone.name
      },
      recurrence: [
        'RRULE:FREQ=DAILY;COUNT=1'
      ],
      attendees: [
        {email: patient.email}
      ]
    })

    result = service.insert_event('primary', event)
    # puts result.inspect
  end
end
