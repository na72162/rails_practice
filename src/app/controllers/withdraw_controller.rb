class WithdrawController < ApplicationController

  def new
  end

  def patch
    # セッションからユーザーIDを取得
    user_id = session[:user_id]

    # ユーザーIDに対応するユーザーをデータベースから取得
    user = User.find(user_id)

    # 後でユーザーのdelete_flgをfalseに設定。基本はtrue。
    user.update(delete_flg: true)

    # memo:ログイン手続きとユーザー登録にも手を加える。
    flash[:success] = "退会手続きをしました！またのご利用をお待ちしております。"
    # ユーザーの情報を更新後、適切なページにリダイレクト
    redirect_to root_url
  end

end
