class UsersController < ApplicationController



  before_action :authenticate_user!


  def index
    @users = User.all
    @book_new = Book.new # renderでindexページにsidebar.html.erbを呼び出すための変数を定義 CreateBook
    @user = current_user #books一覧では自分の画像が表示される
  end

  def show
    #books一覧では自分の画像が表示される。current_userカラムの"レコード"を渡すので、右辺はcurrent_userと表記。
    @user = User.find(params[:id]) # renderでshowページにsidebar.html.erbを呼び出すときにも利用可能。CreateBook
    @books = @user.books #上の@userで取得したidのbooks の値を取り出す。
    @book_new = Book.new # renderでshowページにsidebar.html.erbを呼び出すための変数を定義
  end

  def edit
    @book_new = Book.new # renderでeditページにsidebar.html.erbを呼び出すための変数を定義 CreateBook
    @user = User.find(params[:id]) # renderでeditページにsidebar.html.erbを呼び出すときにも利用可能。
    if @user.id != current_user.id
      redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(current_user.id)
    else
      render 'edit'
    end
  end


  private
    def user_params
     params.require(:user).permit(:name, :introduction, :profile_image)
    end

end