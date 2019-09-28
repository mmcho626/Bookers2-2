class ApplicationController < ActionController::Base






  before_action :configure_permitted_parameters, if: :devise_controller?

  # エラー原因の記述 ヘッダー切り替わらなくなる　後日調べること
  #(before_action :current_user)
  # def current_user
  # return unless session[:user_id]
  # @current_user ||= User.find(session[:user_id])   ←おそらくこれが原因
  # end

  before_action :set_current_user

  def set_current_user
    current_user = User.find_by(id: session[:user_id])
  end





  # サインイン、サインアップ後のリダイレクト先を変更
  # applicationコントローラ内では、@（インスタンス変数)は使えないので、currentでログイン後のマイページを表示

  def after_sign_in_path_for(resource)
    user_path(current_user.id)
  end

  def after_sign_out_path_for(resource)
    root_path
  end



  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:name, :password])
    end



end