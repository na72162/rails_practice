class SessionsController < ApplicationController

  # ユーザー登録と違ってこっちはデータを引っ張ってくるだけなのでUser.newなどの
  # こっちのデータを保存する為の様な事はいらない。
  def new
    render "new"
  end

  #memo:おそらく下の処理に問題があるためヘルパーメソッドをあえて上の方にしている。あとヘルパーメソッドを
  #別ファイルに分けてもなぜかうまくいかないので今度切り分けの方は別途試す。
  # def create
  #   # ここで話されている[:session]はユーザーデータを参照するために使うsessionとは別でrails特有の
  #   #ユーザーがブラウザで情報を送信するたびにパラメータとして送られるもの。詳しく話せば
  #   #ここで指している:sessionはフォームのデータが格納されている部分。
  #   user = User.find_by(email: params[:session][:email].downcase)
  #   if user && user.authenticate(params[:session][:password])
  #   # ここでの?はtrue,falseを判断する為のrubyの慣習
  #   # ユーザーモデルを介してユーザーがログインされているかの真偽値を取得する
  #     if user.activated?
  #       reset_session
  #       # ユーザーIDを格納
  #       if session[:user_id]
  #         # 最終ログイン日時を現在日時に
  #       session[:login_date] = Time.current
  #       session[:login_limit] = 60.minutes
  #         debug_session
  #         flash[:success] = "ログインに成功しました！"
  #         redirect_to mypage_path
  #       else
  #         message  = "ログインに失敗しました "
  #         message += "emailとパスワードの確認をお願いします。"
  #         flash[:warning] = message
  #         redirect_to login_new
  #       end
  #     end
  #   end
  # end

    # def create
    #   user = User.find_by(email: params[:session][:email].downcase)
    #   if user && user.authenticate(params[:session][:password])
    #     if user.activated?
    #       reset_session
    #       if session[:user_id]
    #       session[:login_date] = Time.current
    #       session[:login_limit] = 60.minutes
    #         debug_session
    #         flash[:success] = "ログインに成功しました！"
    #         redirect_to root_url
    #       else
    #         message  = "ログインに失敗しました "
    #         message += "emailとパスワードの確認をお願いします。"
    #         flash[:warning] = message
    #         redirect_to root_url
    #       end
    #     end
    #   end
    # end

    def create
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        reset_session
        log_in user
        redirect_to mypage_path
      else
        flash.now[:danger] = 'Emailもしくはパスワードが違います。'
        # データの更新が無い為renderにする
        render 'new', status: :unprocessable_entity
      end
    end



    def user_params
      # .permitは:userの配列の中に指定したキー。:name, :email, :password,
      # :password_confirmationがあるかどうかを確認するメソッド。
      params.require(:user).permit(:email, :password)
    end

    def generate_session_token
      self.session_token = SecureRandom.urlsafe_base64
    end

    def destroy
      log_out if logged_in?
      reset_session
      flash[:success] = "ログアウトしました"
      redirect_to root_url, status: :see_other
    end

    def log_out
      forget(current_user)
      reset_session
      @current_user = nil
      # memo:この辺の@current_userのインスタンス変数が
      # どう影響するのか調べる
    end

    def log_in(user)
      session[:user_id] = user.id
      session[:session_token] = user.session_token
    end

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
  end
