class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    #authenticateメソッドは認証に失敗したときにfalseを返す
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
     
    else  
      #nowをつけないとリダイレクトした後もメッセージが表示されてしまう
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end  
  end

  def destroy
    log_out if logged_in? #trueの場合のみlog_outを実行
    redirect_to root_url
  end  
end


