class Post < ApplicationRecord
  belongs_to :admin
  has_many :comments, dependent: :destroy # Postが削除されたら関連するCommentも削除
  has_many :post_tags, dependent: :destroy # 中間テーブルの関連付け
  has_many :tags, through: :post_tags # 多対多の関連付け

  # タグの数が3つ以下であることをバリデート
  validate :maximum_three_tags

  private

  def maximum_three_tags
    if tags.size > 3
      errors.add(:tags, "は最大3つまで選択できます")
    end
  end
end