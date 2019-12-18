class UserMailer < ApplicationMailer

  #アカウント有効化リンクをメール送信する
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"  
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
