class Comment < ApplicationRecord
  belongs_to :post
  # コメント本文(body)の存在を必須にする
  # presence: true は、空の文字列やnilでないことを検証する
#  validates :name, presence: true
  validates :body, presence: true
end
