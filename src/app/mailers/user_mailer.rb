class UserMailer < ApplicationMailer
  def pass_remind_send(user, message)
    @user = user
    @message = message
    mail to: user.email, subject: "パスワード再発行完了", template_name: 'passRemindSend'
  end
end

