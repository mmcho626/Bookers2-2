require 'rails_helper'

RSpec.feature "Bookに関するテスト", type: :feature do
  before do
    @user1 = FactoryBot.create(:user, :create_with_books)
    @user2 = FactoryBot.create(:user, :create_with_books)
  end
  feature "ログインしていない状態で" do
    feature "以下のページへアクセスした際のリダイレクト先の確認" do
      scenario "bookの一覧ページ" do
        visit books_path
        expect(page).to have_current_path new_user_session_path
      end

      scenario "bookの詳細ページ" do
        visit book_path(@user1.books.first)
        expect(page).to have_current_path new_user_session_path
      end

      scenario "bookの編集ページ" do
        visit edit_book_path(@user1.books.first)
        expect(page).to have_current_path new_user_session_path
      end
    end
  end

  feature "ログインした状態で" do
    before do
      login(@user1)
    end
    feature "表示内容とリンクの確認" do
      scenario "bookの一覧ページの表示内容とリンクは正しいか" do
        visit books_path
        books = Book.all
        books.each do |book|
          expect(page).to have_link book.title,href: book_path(book)
          expect(page).to have_content book.body
        end
        expect(page).to have_link "",href: edit_user_path(@user1)
        expect(page).to have_content @user1.name
        expect(page).to have_content @user1.introduction
      end

      scenario "bookの一覧ページでtableタグを使用しているか" do
        visit books_path
        expect(page).to have_selector "table"
      end

      scenario "自分のbookの詳細ページでの表示内容とリンクは正しいか" do
        book = @user1.books.first
        visit book_path(book)
        expect(page).to have_content book.title
        expect(page).to have_content book.body
        expect(page).to have_link "",href: edit_book_path(book)
        expect(all("a[data-method='delete']")[-1][:href]).to eq(book_path(@user1.books.first)) #削除ボタンがあることの確認
        expect(page).to have_link @user1.name,href: user_path(@user1)
        expect(page).to have_link "",href: edit_user_path(@user1)
        expect(page).to have_content @user1.name
        expect(page).to have_content @user1.introduction
      end

      scenario "他人のbookの詳細ページでの表示内容とリンクは正しいか" do
        book = @user2.books.first
        visit book_path(book)
        expect(page).to have_content book.title
        expect(page).to have_content book.body
        expect(page).to_not have_link "",href: edit_book_path(book)
        expect(all("a[data-method='delete']")[-1][:href]).to_not eq(book_path(@user1.books.first)) #削除ボタンがないことの確認
        expect(page).to have_link @user2.name,href: user_path(@user2)
        expect(page).to have_content @user2.name
        expect(page).to have_content @user2.introduction
      end
    end

    feature "マイページからbookを投稿" do
      before do
        visit user_path(@user1)
        find_field('book[title]').set("title_a")
        find_field('book[body]').set("body_b")
      end
      scenario "正しく保存できているか" do
        expect {
          find("input[name='commit']").click
        }.to change(@user1.books, :count).by(1)
      end
      scenario "リダイレクト先は正しいか" do
        find("input[name='commit']").click
        expect(page).to have_current_path book_path(Book.last)
        expect(page).to have_content "title_a"
        expect(page).to have_content "body_b"
      end
      scenario "サクセスメッセージが表示されるか" do
        find("input[name='commit']").click
        expect(page).to have_content "successfully"
      end
    end

    feature "book一覧ページからbookを投稿" do
      before do
        visit books_path
        find_field('book[title]').set("title_c")
        find_field('book[body]').set("body_d")
      end
      scenario "正しく保存できているか" do
        expect {
          find("input[name='commit']").click
        }.to change(@user1.books, :count).by(1)
      end
    end

    feature "有効ではない内容のbookを投稿" do
      before do
        visit user_path(@user1)
        find("input[name='book[title]']").set("title_e")
      end
      scenario "保存されないか" do
        expect {
          find("input[name='commit']").click
        }.to change(@user1.books, :count).by(0)
      end
      scenario "リダイレクト先は正しいか" do
        find("input[name='commit']").click
        expect(page).to have_current_path books_path
      end
      scenario "エラーメッセージが表示されるか" do
        find("input[name='commit']").click
        expect(page).to have_content "error"
      end
    end

    feature "自分が投稿したbookの更新" do
      before do
        book = @user1.books.first
        visit edit_book_path(book)
        find_field('book[title]').set('update_title_a')
        find_field('book[body]').set('update_body_b')
        find("input[name='commit']").click
      end
      scenario "bookが更新されているか" do
        expect(page).to have_content "update_title_a"
        expect(page).to have_content "update_body_b"
      end
      scenario "リダイレクト先は正しいか" do
        expect(page).to have_current_path book_path(@user1.books.first)
      end
      scenario "サクセスメッセージが表示されるか" do
        expect(page).to have_content "successfully"
      end
    end

    feature "他人が投稿したbookの更新" do
      scenario "編集ページへアクセスできず、book一覧ページにリダイレクトされるか" do
        visit edit_book_path(@user2.books.first)
        expect(page).to have_current_path books_path
      end
    end

    feature "有効ではない内容のbookの更新" do
      before do
        book = @user1.books.first
        visit edit_book_path(book)
        find_field('book[title]').set(nil)
        find("input[name='commit']").click
      end
      scenario "リダイレクト先は正しいか" do
        expect(page).to have_current_path book_path(@user1.books.first)
      end
      scenario "エラーメッセージが表示されるか" do
        expect(page).to have_content "error"
      end
    end

    feature "bookの削除" do
      before do
        book = @user1.books.first
        visit book_path(book)
      end
      scenario "bookが削除されているか" do
        expect {
          all("a[data-method='delete']").select{|n| n[:href] == book_path(@user1.books.first)}[0].click
        }.to change(@user1.books, :count).by(-1)
      end
      scenario "リダイレクト先が正しいか" do
        all("a[data-method='delete']").select{|n| n[:href] == book_path(@user1.books.first)}[0].click
        expect(page).to have_current_path books_path
      end
    end
  end
end
