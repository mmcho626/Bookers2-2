require 'rails_helper'

RSpec.feature "Userに関するテスト", type: :feature do
  before do
    @user1 = FactoryBot.create(:user, :create_with_books)
    @user2 = FactoryBot.create(:user, :create_with_books)
  end
  feature "ログインしていない状態で" do
    feature "以下のページへアクセスした際のリダイレクト先の確認" do
      scenario "userの一覧ページ" do
        visit users_path
        expect(page).to have_current_path new_user_session_path
      end

      scenario "userの詳細ページ" do
        visit user_path(@user1)
        expect(page).to have_current_path new_user_session_path
      end

      scenario "userの編集ページ" do
        visit edit_user_path(@user1)
        expect(page).to have_current_path new_user_session_path
      end
    end
  end

  feature "ログインした状態で" do
    before do
      login(@user1)
    end
    feature "表示内容とリンクの確認" do
      scenario "userの一覧ページの表示内容とリンク" do
        visit users_path
        expect(page).to have_link "",href: user_path(@user1)
        expect(page).to have_content @user1.name
        expect(page).to have_content @user1.introduction
        expect(page).to have_link "",href: edit_user_path(@user1)
        expect(page).to have_link "",href: user_path(@user2)
        expect(page).to have_content @user2.name
      end

      scenario "userの一覧ページでtableタグを使用しているか" do
        visit users_path
        expect(page).to have_selector "table"
      end

      scenario "自分の詳細ページの表示内容とリンク" do
        visit user_path(@user1)
        expect(page).to have_content @user1.name
        expect(page).to have_content @user1.introduction
        expect(page).to have_link "",href: edit_user_path(@user1)

        @user1.books.each do |book|
          expect(page).to have_link book.title,href: book_path(book)
          expect(page).to have_content book.body
        end
      end

      scenario "自分の詳細ページでno-imageの画像が表示されているか" do
        visit user_path(@user1)
        expect(page).to have_selector "img" #画像を投稿してない状態でimgタグがあるかどうかによる判断（no-image）
      end

      scenario "他人の詳細ページの表示内容とリンク" do
        visit user_path(@user2)
        expect(page).to have_content @user2.name
        expect(page).to have_content @user2.introduction

        @user2.books.each do |book|
          expect(page).to have_link book.title,href: book_path(book)
          expect(page).to have_content book.body
        end
      end
    end

    feature "自分のプロフィールの更新" do
      before do
        visit edit_user_path(@user1)
        find_field('user[name]').set('updated_name')
        find_field('user[introduction]').set('updated_inttroduction')
        find('input[type="file"]').set(File.dirname(__FILE__) + "/../" +'files/sample.jpeg')
        find("input[name='commit']").click
      end
      scenario "userが更新されているか" do
        expect(page).to have_content "updated_name"
        expect(page).to have_content "updated_inttroduction"
        expect(User.find(1).profile_image_id).to be_truthy
      end
      scenario "リダイレクト先は正しいか" do
        expect(page).to have_current_path user_path(@user1)
      end
      scenario "サクセスメッセージが表示されるか" do
        expect(page).to have_content "successfully"
      end
    end

    feature "他人のプロフィールの更新" do
      scenario "ページへアクセスできず、マイページにリダイレクトされるか" do
        visit edit_user_path(@user2)
        expect(page).to have_current_path user_path(@user1)
      end
    end

    feature "有効ではない内容のuserの更新" do
      before do
        visit edit_user_path(@user1)
        find_field('user[name]').set(nil)
        find("input[name='commit']").click
      end
      scenario "リダイレクト先が正しいか" do
        expect(page).to have_current_path user_path(@user1)
      end
      scenario "エラーメッセージが表示されるか" do
        expect(page).to have_content "error"
      end
    end
  end
end
