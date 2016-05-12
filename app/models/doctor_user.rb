require 'google/apis/calendar_v3'

class DoctorUser < User
  has_many :booked_hours, foreign_key: 'doctor_user_id', dependent: :delete_all
  has_many :patient_users, through: :booked_hours

  # has_many :reviews, foreign_key: 'doctor_user_id', dependent: :delete_all

  has_one :doctor_info, dependent: :delete

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
  scope :by_top_doctors, -> top_doctors {
    if top_doctors == 'true'
      joins(:doctor_info)
      .order('doctor_infos.feedback_count DESC')
      .by_name_order('ASC')
    end
  }

  before_create :validate_doctor_info

  def self.by_appointment_time time
    joins(:doctor_info).where("? BETWEEN doctor_infos.hours_from::time AND doctor_infos.hours_to::time", Time.parse(time).strftime("%H:%M"))
    # joins(:open_hours).where("? BETWEEN open_hours.from::time AND open_hours.to::time", Time.parse(time).strftime("%H:%M"))
  end

  def build_default_info
    self.build_doctor_info(hours_from: '8:00 AM', hours_to: '6:00 PM', days: [1,2,3,4,5,6])
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

  def feedback_count
    if self.doctor_info.present?
      return self.doctor_info.feedback_count
    else
      return '0'
    end
  end

  def feedback_score
    if self.doctor_info.present?
      return self.doctor_info.feedback_score
    else
      return 0
    end
  end

  def reviews
    Review.joins(:booked_hour).where("booked_hours.doctor_user_id = ?", self.id).order(updated_at: :desc).limit(10)
  end

  # static
  def self.top_doctors
    DoctorUser.joins(:doctor_info).order('doctor_infos.feedback_score DESC').limit(6)
  end

  def import_from_google_calendar
    identity = self.identities.find_with_provider('google_oauth2')
    return false if identity.nil?

    client = Signet::OAuth2::Client.new(
      access_token: identity.token
    )
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

    booked_list = self.booked_hours.where(["booked_hours.from >= ?", Time.now]).order(:from)
    calendar_list.items.each do |calendar|
      booked_list = booked_list + [BookedHour.new(
        doctor_user_id: self.id,
        title: calendar.summary,
        from: calendar.start.date_time,
        to: calendar.end.date_time,
        status: BookedHour.statuses[:imported]
      )]
    end
    booked_list = merge_overlapping_hours_list(booked_list)
    booked_list.each do |bh|
      bh.save!
    end
    true
  end

  def fullcalender_booked_hours
    self.booked_hours.where.not(status: BookedHour.statuses[:canceled]).inject([]) do |booked_hours, bh|
      booked_hours + [{
        title: bh.title,
        start: bh.from,
        end: bh.to,
        rendering: bh.imported? || bh.from < Time.now || bh.approved? ? 'background' : ''
      }]
    end
  end

  def upcoming_appointments
    self.booked_hours.approved.where('booked_hours.from >= ?', Time.now).where('patient_user_id IS NOT NULL').order('booked_hours.from DESC')
  end

  def pending_appointments
    self.booked_hours.pending.where('booked_hours.from >= ?', Time.now).order('booked_hours.from DESC')
  end

  def past_appointments
    self.booked_hours
      .where('booked_hours.patient_user_id IS NOT NULL')
      .where('booked_hours.from < ? OR booked_hours.status = ?', Time.now, BookedHour.statuses[:approved]).order('booked_hours.from DESC')
  end


  def update_reviews!
    doctor_info = self.doctor_info
    if doctor_info.present?
      doctor_info.feedback_score = Review.joins(:booked_hour).where("booked_hours.doctor_user_id = ?", self.id).average(:avg_score)
      doctor_info.feedback_count = Review.joins(:booked_hour).where("booked_hours.doctor_user_id = ?", self.id).count
      doctor_info.save!
    end
  end
  
  def self.export_to_yaml_file
    file_path ||= File.join(Rails.root, 'data/doctors.yml')
    File.open(file_path, 'w+') {
      |f| f << DoctorUser.joins(:doctor_info).joins('LEFT OUTER JOIN specialities ON doctor_infos.speciality_id = specialities.id').select(
        :first_name,
        :last_name,
        :email,
        :avatar_file_name,
        :bio,
        'specialities.name as speciality'
      ).order(:id).to_yaml
    }
  end

  # def self.import_from_yaml_file
  #   h = YAML::load_file( File.join(Rails.root, 'data/doctors.yml' ) )
  #   list = h.is_a?(Array) ? h : h.values.first
  #   list.each do |yml_record|
  #     record = where(id: yml_record.id) || new
  #     record.attributes = yml_record.attributes.select{|attr| attr.to_s != 'id' }
  #     puts "#{record.new_record? ? '+' : '*'} %16s | %24s" % [record.email, record.full_name] if Rails.env.development?
  #     record.save
  #   end
  #   puts "|- Loaded #{list.count} doctors"
  # end

  private

  def validate_doctor_info
    if self.doctor_info.nil?
      self.build_default_info
      self.save!
    end
  end

  def hours_overlap?(a, b)
    a.from < b.to && b.from < a.to
  end

  def merge_hours(a, b)
    neq = false
    if a.from == b.from && a.to == b.to
      if a.status == BookedHour.statuses[:imported]
        # new_title = b.title
        # new_status = b.status
        return b
      elsif b.status == BookedHour.statuses[:imported]
        # new_title = a.title
        # new_status = a.status
        return a
      else
        neq = true
      end
    end

    if neq
      if a.title.include?(b.title)
        new_title = a.title
        new_status = a.status
      elsif b.title.include?(a.title)
        new_title = b.title
        new_status = b.status
      else
        new_title = "#{a.title}, #{b.title}"
        new_status = BookedHour.statuses[:imported]
      end
    end

    bh = BookedHour.new(
      doctor_user_id: self.id,
      title: new_title,
      from: round_time([a.from, b.from].min, false),
      to: round_time([a.to, b.to].max, true),
      status: new_status
    )
    a.destroy if a.id.present?
    b.destroy if b.id.present?
    bh
  end

  def merge_overlapping_hours_list(hours_list)
    hours_list.sort_by(&:from).inject([]) do |hours_list, hours|
      if !hours_list.empty? && hours_overlap?(hours_list.last, hours)
        hours_list[0...-1] + [merge_hours(hours_list.last, hours)]
      else
        hours_list + [hours]
      end
    end
  end

  def round_time(time, up = true)
    seconds = 60 * 30
    if up
      Time.at((time.to_f / seconds).round * seconds)
    else
      Time.at((time.to_f / seconds).floor * seconds)
    end
  end

end
