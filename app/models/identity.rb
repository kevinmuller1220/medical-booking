class Identity < ActiveRecord::Base
  belongs_to :user

  def self.find_with_omniauth(auth)
    find_by(uid: auth['uid'], provider: auth['provider'])
  end

  def self.find_with_provider(provider)
    find_by(provider: provider)
  end

  def self.create_with_omniauth(auth)
    create(uid: auth['uid'], provider: auth['provider'],
    first_name: auth.info.first_name, last_name: auth.info.last_name,
    email: auth.info.email, image: auth.info.image)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
