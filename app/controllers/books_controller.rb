class BooksController < ApplicationController

  before_action :authenticate_user!

  def new
  	@book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
  if @book.save
    flash[:notice] = "You have creatad book successfully."
    redirect_to book_path(@book.id)
  else
    @books = Book.all
    @user = current_user #indexのアクションで部分テンプレートのアクションが起こせるように記述
    render 'index'
  end

  end

  def index
    @book = Book.new
  	@books = Book.all
    @users = User.all
    @user = current_user #books一覧では自分の画像が表示される。current_userカラムの"レコード"を渡すので、右辺はcurrent_userと表記。
  end

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new # renderでshowページにsidebar.html.erbを呼び出すための変数を定義
    @user = @book.user #Nの@bookから1のuserの情報を取り出して@bookの左辺のidを代入
  end

  def edit
    @book_new = Book.new # renderでeditページにsidebar.html.erbを呼び出すための変数を定義
      @book = Book.find(params[:id])
    if @book.user_id != current_user.id
      flash[:notice] = "権限がありません"
      redirect_to books_path
    end

  end

  def update
     @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all
      @user = current_user #books一覧では自分の画像が表示される。current_userカラムの"レコード"を渡すので、右辺はcurrent_userと表記。
      render 'index'
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end


  private

    def book_params
      params.require(:book).permit(:title, :body)
    end

end
