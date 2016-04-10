class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "50x50>" }, default_url: 'missing.jpg'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  belongs_to :role
  has_many :identities, dependent: :delete_all

  geocoded_by :full_address

  after_validation :geocode

  def doctor?
    self.type == "DoctorUser"
  end
  def patient?
    self.type == "PatientUser"
  end
  def super_admin?
    self.type == "AdminUser"
  end

  def self.create_with_omniauth(auth)
    user = User.find_by_email(auth.info.email)
    if user.nil?
      user = create(
        email: auth.info.email,
        password: Devise.friendly_token[0,20],
        first_name: auth.info.first_name,
        last_name: auth.info.last_name,
        avatar: auth.info.image,
        confirmed_at: Time.now.utc
      )
    end
    user
  end

  def google_oauth2
    identities.where( :provider => "google_oauth2" ).first
  end

  def facebook
    identities.where( :provider => "facebook" ).first
  end

  def disconnect_from_google
    self.identities.find_with_provider('google_oauth2').destroy
  end

  def disconnect_identity(token, provider)
    require 'net/http'
    if provider == 'google_oauth2'
      uri = URI.parse("https://accounts.google.com/o/oauth2/revoke?token=#{token}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      json = JSON.parse response.body
      if json[:error].present?
        return false
      else
        self.identities.find_by_provider(provider).destroy
        return true
      end
    else
      return false
    end
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def full_address
    "#{address}, #{city}, #{state}, #{zipcode}, US"
  end

  def avatar_from_url(url)
    self.avatar = open(url)
  end
end
