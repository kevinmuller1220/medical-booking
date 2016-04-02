class Speciality < ActiveRecord::Base
  has_many :doctor_infos

  before_create :default_slug
  def default_slug
    if self.slug.blank?
      self.slug = self.name.parameterize
    end
  end

  def self.top_specialties
    Speciality.all.limit(5)
  end
end
