class BookCommentsController < ApplicationController



	def create
		book = Book.find(params[:book_id])
		comment = current_user.book_comments.new(book_comment_params)
		comment.book_id= book.id
		comment.save
		redirect_to book_path(book)
	end


	def edit
        @book_new = Book.new # renderでeditページにsidebar.html.erbを呼び出すための変数を定義
	    @book_comment = BookComment.find(params[:id])
	    if @book_comment.user_id != current_user.id
		    flash[:notice] = "権限がありません"
		    redirect_to books_path
	    end

    end


    def update
    	@book = Book.find(paarams[:id])
        @book_comment = BookComment.find(params[:id])
	    if @book_comment.update(book_comment_params)
	       flash[:notice] = "You have updated book_comment successfully."
	       redirect_to book_path(@book)
	    else
	       @books = Book.all
	       @user = current_user #books一覧では自分の画像が表示される。current_userカラムの"レコード"を渡すので、右辺はcurrent_userと表記。
	       render 'index'
	    end
	end




    def destroy
    	@books = Book.all
		book_comment = BookComment.find(params[:id])
	    if @book_comment.destroy(book_comment_params)
	       flash[:notice] = "You have destroied book_comment succesfully"
	       redirect_to books_path
	    else
           @book = Book.find(params[:id])
           @user = current_user
           redirect_to book_path(@book)
        end
	end



	private
	def book_comment_params
		params.require(:book_comment).permit(:user_id, :book_id, :comment)

end
end