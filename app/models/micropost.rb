class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
                #↑ラムダ式         ↑降順に並び替え
  #default_scope を使うとorderが指定できる 
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true  #presenceは指定された属性が空でないことを確認する
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private
    #アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
