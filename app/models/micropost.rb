class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, length: {maximum: Settings.micropost_content_maxlen},
    presence: true
  validate  :picture_size

  default_scope ->{order created_at: :desc}
  scope :user_microposts, ->(user_id){where "user_id = ?", user_id}
  scope :feed_posts, ->(following_ids, id){where "user_id IN (?) OR user_id = ?", following_ids, id}

  mount_uploader :picture, PictureUploader

  private

  # Validates the size of an uploaded picture.
  def picture_size
    errors.add :picture, t("upload_image_fail_msg") if
      picture.size > Settings.limit_size_image.megabytes
  end
end
