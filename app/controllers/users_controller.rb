class UsersController < ApplicationController
  #before_actionはヘルパーメソッド
  #ログイン済みのユーザーじゃないとindex,edit,updateアクションは動かない
  before_action :logged_in_user, only: [:index, :edit, :update]
  #正しいユーザー出ないとeditとupdateは動かない
  before_action :correct_user, only: [:edit, :update]
  #管理者ユーザーでないとdestroyは動かない
  before_action :admin_user, only: :destroy

  #ユーザー一覧ページのページネーション
  def index
    @users = User.paginate(page: params[:page], per_page: 10)
            #↑User.allと同じ意味
  end  

  #ユーザープロフィール
  def show
    @user = User.find(params[:id])
  end

  #新規ユーザー作成
  def new
    @user = User.new 
    #空のユーザーを作る これをしないと入力画面のform_forで回すものがないって怒られる saveしないと登録されない
  end

  #新規ユーザー登録
  def create
    #引数にuser_paramsメソッド(Strong parameterした値)を指定
    @user = User.new(user_params)
    #ユーザー登録ができたら
    if @user.save
      # UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new' #登録に失敗したら入力画面に戻る
    end
  end

  #ユーザー編集ページ
  def edit
    @user = User.find(params[:id])
  end

  #ユーザー情報更新
  def update
    @user = User.find(params[:id])
     #引数にuser_params(Strong parameterした値)を指定
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  #ユーザー削除(管理者だけ)
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end  

  #privateで外から変更がかけられないようにする
  private
  
    def user_params
      #Strong Parameters　ユーザー登録で入力された値だけを受け入れてそれ以外の悪意ある変更から守る adminは保存されないからほかの人に管理者権限が与えられることがない
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    #before_action
    def logged_in_user
      unless logged_in? #ログインしていなかったら　
        store_location
        flash[:danger] =  "Please log in."
        redirect_to login_url
      end
    end

    #before_action
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) #
      #current_user?はヘルパーメソッド(サインインしているユーザーを取得する)
      #正しいユーザーでない場合はトップ画面に戻る(違うユーザーがurlにIdベタ打ちした時とか)
    end  

    #before_action
    def admin_user
      redirect_to(root_url) unless current_user.admin?
      #管理者でない場合はトップ画面に戻る
    end      
end