class Post < ApplicationRecord
  belongs_to :admin
  has_many :comments, dependent: :destroy # Postが削除されたら関連するCommentも削除
  has_many :post_tags, dependent: :destroy # 中間テーブルの関連付け
  has_many :tags, through: :post_tags # 多対多の関連付け

end