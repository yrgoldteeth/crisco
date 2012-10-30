class Link < ActiveRecord::Base
  attr_accessible :original_url, :slug

  validate :original_url, :slug, presence: true
  validate :slug, unique: true

  after_initialize :handle_slug_creation, unless: :slug?

  def to_param
    slug
  end

  def handle_slug_creation
    self.slug = SecureRandom.urlsafe_base64(5)
  end

end
