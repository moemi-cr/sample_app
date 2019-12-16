class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    
    if user && user.authenticate(params[:session][:password])
      #authenticate → モデルでhas_secure_passwordを宣言していると自動的に使用できるようになり、入力されたパスワードを暗号化し、DBに登録されているpassword_digestと一致するか検証
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      #チェックボックスの送信結果を処理する
      redirect_back_or(user)
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


