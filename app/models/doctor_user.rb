class DoctorUser < User
  has_many :appointments, foreign_key: 'doctor_user_id'
  has_many :patient_users, through: :appointments, class_name: "PatientUser"

  has_many :reviews, foreign_key: 'doctor_user_id'

  # has_many :open_hours
  has_many :booked_hours
  has_one :doctor_info

  # accepts_nested_attributes_for :open_hours, :allow_destroy => true
  accepts_nested_attributes_for :booked_hours, :allow_destroy => true
  accepts_nested_attributes_for :doctor_info, :allow_destroy => true

  scope :by_zipcode, -> zip { where(:zipcode => zip) }
  scope :by_state, -> state { where(:state => state) }
  scope :by_city, -> city { where(:city => city) }
  scope :by_speciality_id, -> speciality_id { joins(:doctor_info).where( "doctor_infos.speciality_id = #{speciality_id}" ) }
  scope :by_speciality, -> speciality { joins(doctor_info: :speciality).where('LOWER(specialities.name) LIKE ?', "%#{speciality.downcase}%") }
  scope :by_appointment_date, -> date { where('? = ANY (days)', date) }
  scope :by_name_order, -> name_order { name_order == 'desc' ? order('(first_name || last_name) DESC') : order('(first_name || last_name) ASC') }
  scope :by_distance_order, -> distance_order, base_lng, base_lat {
    distance_order == 'desc' ? order("distance(#{base_lat}, #{base_lng}, latitude, longitude) DESC") : order("distance(#{base_lat}, #{base_lng}, latitude, longitude) ASC")
  }

  before_create :validate_doctor_info

  def self.by_appointment_time time
    joins(:doctor_info).where("? BETWEEN doctor_infos.hours_from::time AND doctor_infos.hours_to::time", Time.parse(time).strftime("%H:%M"))
    # joins(:open_hours).where("? BETWEEN open_hours.from::time AND open_hours.to::time", Time.parse(time).strftime("%H:%M"))
  end

  def build_default_info
    self.build_doctor_info(hours_from: '8:00 AM', hours_to: '6:00 PM', days: [1,2,3,4,5,6])
  end

  def import_from_google_calendar(token)
    client = Signet::OAuth2::Client.new(access_token: token)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client
    limit = 1000
    now = Time.now.iso8601
    page_token = nil
    calendar_list = service.list_events(
      'primary',
      max_results: [limit, 100].min,
      single_events: true,
      order_by: 'startTime',
      time_min: now,
      time_max: (Time.now + 7.days).iso8601,
      page_token: page_token,
      fields: 'items(id,summary,start,end),next_page_token'
    )
    calendar_list.items.each do |calendar|
      
    end
  end
  # shortcut to doctor_info attributes
  def days
    if self.doctor_info.present?
      self.doctor_info.days
    else
      []
    end
  end

  def speciality
    if self.doctor_info.present? && self.doctor_info.speciality.present?
      self.doctor_info.speciality.name
    else
      ''
    end
  end

  def house_calls
    if self.doctor_info.present?
      self.doctor_info.house_calls
    else
      false
    end
  end

  def website
    if self.doctor_info.present?
      self.doctor_info.website
    else
      ''
    end
  end

  def bio
    if self.doctor_info.present?
      self.doctor_info.bio
    else
      ''
    end
  end

  def hours_from
    if self.doctor_info.present?
      self.doctor_info.hours_from
    else
      ''
    end
  end

  def hours_to
    if self.doctor_info.present?
      self.doctor_info.hours_to
    else
      ''
    end
  end

  # static
  def self.top_doctors
    DoctorUser.all
  end

  private
  def validate_doctor_info
    if self.doctor_info.nil?
      self.build_default_info
      self.save!
    end
  end
end
