class SessionsController < ApplicationController

  # ユーザー登録と違ってこっちはデータを引っ張ってくるだけなのでUser.newなどの
  # こっちのデータを保存する為の様な事はいらない。
  def new
    render new
  end

  def destroy
    log_out if logged_in?
    reset_session
    flash[:success] = "ログアウトしました"
    redirect_to root_url, status: :see_other
  end

  private
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
    # memo:この辺の@current_userのインスタンス変数が
    # どう影響するのか調べる
  end

  private
  def log_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end

  private
  def current_user
    # @無しがローカル変数、有りがインスタンス変数。ローカルはその場の処理でしか使えない。
    # インスタンス変数は他の処理の受け渡しやクラス内でのやり取りで主に使う。
    if (user_id = session[:user_id])
      # (id: user_id)のid側はDBのカラムを指定していてuser_idは
      user = User.find_by(id: user_id)
      if user && session[:session_token] == user.session_token
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  #memo:おそらく下の処理に問題があるためヘルパーメソッドをあえて上の方にしている。あとヘルパーメソッドを
  #別ファイルに分けてもなぜかうまくいかないので今度切り分けの方は別途試す。

  def create
    # 基本モデルクラスはグローバルなので途中のnewの所でUser宣言などしなくても
    # ActiveRecord内のメソッドを扱う目当てでUserを使う事ができる。
    # [:session][:email]は前のフォーム段階でscope: :sessionと指定しているので
    # params[:session][:email]となっている。
    login = User.find_by(email: params[:session][:email].downcase)
    # この例では、session[:session_token] を User モデルの session_token カラムに保存しています。
    # ログイン情報とemail情報両方を一括判定させて悪意のある人にどっちがあっているかの情報を与えるのを避ける
    # 下の処理だとユーザー登録段階でユーザーモデルでhas_secure_passwordを使っているのでパスワードがハッシュ化
    # されているので検索できない。
    # if user = User.find_by(email: @login.email, password_digest: @login.password)
    # authenticateはhas_secure_passwordでハッシュ化されたパスワードの解析に必要。
    if user && user.authenticate(params[:session][:password])
      reset_session
      # セッション情報の保存
      # idの保存
      session[:user_id] = user.id
      # セッションハイジャック対策の為のトークン生成
      session[:session_token] = @login.generate_session_token
      # トークン生成後にdb側に保存

      # 最終ログイン日時を現在日時に
      session[:login_date] = Time.current
      # ログイン制限時間を設定
      session[:login_limit] = 60.minutes

      @login = User.find(session[:user_id])
      # まずユーザを見つけます
      @login.update(session_token: session[:session_token])
      # セッショントークンをデータベースに保存します
      # ユーザーIDを格納
      # デバック情報の確認
      debug_session
      #フラッシュメッセージ
      flash[:success] = "ログインに成功しました！"
      # DBの更新があるのでredirect_toでページ指定する。
      redirect_to mypage_path
    else
      reset_session
      flash.now[:alert] = "ログインに失敗しました"
      render "new"
    end

    def user_params
      # .permitは:userの配列の中に指定したキー。:name, :email, :password,
      # :password_confirmationがあるかどうかを確認するメソッド。
      params.require(:user).permit(:email, :password)
    end

    private
    def generate_session_token
      self.session_token = SecureRandom.urlsafe_base64
    end
  end
end
