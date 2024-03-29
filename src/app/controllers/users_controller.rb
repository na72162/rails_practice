class UsersController < ApplicationController

  def new
    # レンダーを使ってインスタンス変数をやり取りしないと
    # データの保持ができない
    @signup = User.new
    render 'new'
  end

  def create
    # ここのUserはUserモデルを引っ張ってきている。そこで継承されているクラスからnewメソッドを引っ張ってきている。
    @signup = User.new(user_params)
    if @signup.save
      # 現在のセッションの破棄
      reset_session
      # セッション情報の保存
      # idの保存
      session[:user_id] = @signup.id
      # セッションハイジャック対策の為のトークン生成
      session[:session_token] = @signup.generate_session_token
      # トークン生成後にdb側に保存
      @signup.update(session_token: session[:session_token])
      # 最終ログイン日時を現在日時に
      session[:login_date] = Time.current
      # ログイン制限時間を設定
      session[:login_limit] = 60.minutes
      # ユーザーIDを格納
      # デバック情報の確認
      debug_session
      #フラッシュメッセージ
      flash[:success] = "ユーザー登録に成功しました！"
      # redirect_toにインスタンス変数を宣言するとそれに対応したshowファイルに遷移される。
      # 今回の場合だとuser/showになる
      redirect_to mypage_path
    else
      # status: :unprocessable_entityは422ステータスコードで
      render 'new', status: :unprocessable_entity
    end
  end

  def patch
    redirect_to withdraw_path
  end

  def show
  end

  # privateはこのコントローラー内で完結させるためのもの。
  # ヘルパーメソッドフォルダで用意されているのは基本ビューファイルで使う想定なので
  # そのままだとコントローラーだと使えない。
  #一応 include UsersHelperなどでも使える様にはなるけど一般的には下の方法がよい。
  #(一つのファイルで完結できるので)

  private
  def user_params
    # .permitは:userの配列の中に指定したキー。:name, :email, :password,
    # :password_confirmationがあるかどうかを確認するメソッド。
    params.require(:user).permit(:email, :password,
    :password_confirmation)
  end

  private
  def debug_session
    Rails.logger.debug "Session Data: #{session.inspect}"
  end

  private
  def generate_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end

end
