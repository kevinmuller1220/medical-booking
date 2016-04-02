class Service < ActiveRecord::Base
  before_create :default_slug
  def default_slug
    if self.slug.blank?
      self.slug = self.name.parameterize
    end
  end
end
