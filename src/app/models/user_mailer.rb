class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    @message = message
    mail to: user.email, subject: "パスワード再発行完了", template_name: 'passRemindSend'
  end
end

