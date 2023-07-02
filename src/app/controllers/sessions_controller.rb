class SessionsController < ApplicationController

  def new
    @login = User.new
    render 'new'
  end

  def create
    @login = User.new(user_params)
    # この例では、session[:session_token] を User モデルの session_token カラムに保存しています。
    # ログイン情報とemail情報両方を一括判定させて悪意のある人にどっちがあっているかの情報を与えるのを避ける
    if user = User.find_by(email: @login.email, password: @login.password)
      reset_session
      # セッション情報の保存
      # idの保存
      session[:user_id] = @login.id
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

    def destroy
      log_out
      flash[:success] = "ログアウトしました"
      redirect_to root_url, status: :see_other
    end

  #   ActionController::ParameterMissing in UsersController#create
  # param is missing or the value is empty: user
  # Did you mean?
  # session
  # authenticity_token
  # controller
  # action
  # Extracted source (around line #54):
  # 52
  # 53
  # 54
  # 55
  # 56
  # 57

  #     # .permitは:userの配列の中に指定したキー。:name, :email, :password,
  #     # :password_confirmationがあるかどうかを確認するメソッド。
  #     params.require(:user).permit(:email, :password,
  #     :password_confirmation)
  #   end

  ############################### 次回ここのエラーの解決から入る。

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

次エラーの解決
