class User < ApplicationRecord
  # データベースに保存する前の処理、ここでメールアドレスを小文字に変換している。
  before_save { self.email = email.downcase }
  # ここはバリテーション処理、validates :nameで対応するキーを設定。presence: trueは空かどうかの確認。
  # { maximum: 50 }は文字数制限
  # 正規表現の設定
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # 上と基本同じ、uniqueness: trueは被りがないかの確認。
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  # ハッシュ化されたパスワードを保存する処理
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end

