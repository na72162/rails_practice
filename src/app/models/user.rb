class User < ApplicationRecord
  has_secure_password
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
  validates :password, presence: true, length: { minimum: 6 }

  def generate_session_token
    # selfはこのクラスを元に生成されたインスタンスを指す。
    self.session_token = SecureRandom.urlsafe_base64
  end

  # 特定のインスタンスからactivated属性を引っ張ってくるメソッド
  # ユーザーモデルがユーザー情報が認識されているかの真偽値属性を持っているのでそこから
  # ユーザーがログインしているかどうかの真偽値を取得。確認する。
  def activated?
    self.activated
  end

  class UserMailer < ApplicationMailer
    def pass_remind_send(user)
      @user = user
        # <%# この場合、template_name: 'passRemindSend'と指定されているので、メ
        # ールの本文としてapp/views/user_mailer/passRemindSend.html.erbや
        # app/views/user_mailer/passRemindSend.text.erb %>
        # 基本は#<%# app/views/メーラーのクラス名/アクション名.html.erb
        # # やapp/views/メーラーのクラス名/アクション名.text.erb %>
      mail to: user.email, subject: "パスワード再発行認証", template_name: 'passRemindSend'
    end
  end


  def create_reset_digest
    # 対象インスタンスに新しいトークンを持たせてそれを対象カラムreset_digest・reset_sent_at
    # に追加する処理
    self.reset_token = User.new_token
    update_columns(password_digest:  User.digest(reset_token),
                reset_sent_at: Time.zone.now)
  end

  # トークンを生成する
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 渡された文字列をハッシュ化する
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end

