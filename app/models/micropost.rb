class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, length: {maximum: Settings.micropost_content_maxlen},
   presence: true

  default_scope ->{order created_at: :desc}
  scope :user_microposts, ->(user_id){where "user_id = ?", user_id}

  mount_uploader :picture, PictureUploader
end
