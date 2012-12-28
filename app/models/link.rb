class Link < ActiveRecord::Base
  attr_accessible :original_url, :slug

  validate :original_url, :slug, presence: true
  validate :slug, unique: true

  after_initialize :handle_slug_creation, unless: :slug?

  belongs_to :user
  has_many :visits

  def to_param
    slug
  end

  def handle_slug_creation
    self.slug = SecureRandom.urlsafe_base64(4)
  end

end
