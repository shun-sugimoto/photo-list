class Image < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :google_id,presence: true
  validates :comment, length: { maximum: 300 }
end