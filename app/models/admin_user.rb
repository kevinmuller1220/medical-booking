class AdminUser < User
  before_create :validate_type
  def validate_type
    if self.type != 'AdminUser'
      self.type = 'AdminUser'
    end
  end
end
