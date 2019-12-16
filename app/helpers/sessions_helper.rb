module SessionsHelper
 
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id #userIdをsessionに入れる
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    #署名付きcookie
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id]) 
        #log_inメソッドで飛ばしたセッションの内容がnilじゃなければ(ログインしていたら)
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
    #↑ヘルパーメソッド　現在ログインしているユーザーがいるかどうか
  end

  #永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end  

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

   # アクセスしようとしたURLを覚えておく(フレンドリーフォワーディング)
   def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト（フレンドリーフォワーディング）
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default) #:forwarding_urlがnilだったらdefaultのurlに飛ぶ(defaultはプロフィール画面)
    session.delete(:forwarding_url)
  end
end