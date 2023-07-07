class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      # 上から取得したemailに関連したダイジェスト(ハッシュ化みたいなの)を生成。
      # メソッドはUserから生成
      @user.create_reset_digest
      # pass_remind_sendは@userのデータを引数にメールの内容を作成。
      # deliver_nowはメール送信のメソッド
      # memo:エラーは出ないのになぜかメールの送信が出来ない。後で修正する。
      UserMailer.pass_remind_send(@user,"対象のEmailにパスワードを送信しました。ログイン後パスワードの変更をお願いします").deliver_now
      redirect_to login_mew_path
    else
      UserMailer.pass_remind_send(@user, "Emailが見つかりませんでした").deliver_now
      render user_mailer_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end

