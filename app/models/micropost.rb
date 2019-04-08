class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order created_at: :desc}
  scope :load_by_user_id, ->(id){where "user_id = ?", id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.app.micropost.content_length}
  validate :picture_size

  private

  # Validates the size of an uploaded picture.
  def picture_size
    return unless picture.size > Settings.app.micropost.image_size_mb.megabytes
    errors.add(:picture, t("shared.micropost_form.maximum_size_err"))
  end
end
