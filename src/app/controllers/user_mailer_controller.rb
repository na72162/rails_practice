class UserMailerController < ApplicationController

  def pass_remind_send
    @user = User.new
    render 'passRemindSend'
    # レンダー事などはpassRemindSend_pathいらない。基本viewの時だけ。
  end

  # skip_before_action :require_user_logged_in

  def create
    @user = User.find_by(email: params[:email])

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "対象のEmailにリセット用パスワードを送信しました。"
      redirect_to root_url
    else
      flash.now[:danger] = "Emailが存在しません。"
      render 'pass_Remind_Send_path'
    end
  end

  def update
    begin
      # ユーザーをメールアドレスで検索し、delete_flgが0のものを取得
      user = User.find_by([:email], delete_flg: false)

      # パスワードをハッシュ化して更新
      user.update(password: BCrypt::Password.create(params[:password]))

      # メール送信
      UserMailer.password_reset(user).deliver_now

      # セッションをクリア
      reset_session
      flash[:success] = "パスワードの再発行が完了しました。メールをご確認ください。"

      # ログインページにリダイレクト
      redirect_to passRemindRecieve_path
      rescue => e
      Rails.logger.error "エラー発生: #{e.message}"
      flash[:error] = "エラーが発生しました。"
      render
    end
  end

  def edit
    begin
      # ユーザーをメールアドレスで検索し、delete_flgが0のものを取得
      user = User.find_by([:email], delete_flg: false)

      # パスワードをハッシュ化して更新
      user.update(password: BCrypt::Password.create(params[:password]))

      # メール送信
      UserMailer.password_reset(user).deliver_now

      # セッションをクリア
      reset_session
      flash[:success] = "パスワードの再発行が完了しました。メールをご確認ください。"

      # ログインページにリダイレクト
      redirect_to passRemindRecieve_path
      rescue => e
      Rails.logger.error "エラー発生: #{e.message}"
      flash[:error] = "エラーが発生しました。"
      render :edit
    end
  end
end




