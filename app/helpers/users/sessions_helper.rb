# frozen_string_literal: true

module Users::SessionsHelper
  # 渡されたユーザーでログインする
  def user_log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def user_logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def user_log_out
    reset_session
    @current_user = nil  # rubocop:disable Rails/HelperInstanceVariable
  end
end
