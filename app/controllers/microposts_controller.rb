class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy

    def create
        @micropost = current_user.microposts.build(micropost_params) #:contentと:pictureを指定している
        if @micropost.save
          flash[:success] = "Micropost created!"
          redirect_to root_url
        else
          @feed_items = []
          render 'static_pages/home'
        end
      end
    
      def destroy
        if @micropost == nil
            flash[:danger] ="@micropost is nil"
            redirect_to root_url
        else
            @micropost.destroy
            flash[:success] = "Micropost deleted"
            redirect_to request.referrer || root_url
        end
      end
    
    
      private
    
      #createメソッドで呼ばれる
      def micropost_params
        params.require(:micropost).permit(:content, :picture)
        #.requireがデータのオブジェクト名を決めて、.permitで保存の処理ができるキーを指定
      end
  
      def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
      end
end
