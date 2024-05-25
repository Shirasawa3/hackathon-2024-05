# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  # Devise によってログインを行った際のリダイレクト先を取得する
  # @param resource [ActiveModel] ログインを行ったモデル
  def after_sign_in_path_for(resource)
    if resource.is_a? CorporateUser
      corp_items_path
    else
      root_path
    end
  end

  # Devise によってログアウトを行った際のリダイレクト先を取得する
  # @param resource [Symbol] ログアウトを行ったモデルの型を表す Symbol
  def after_sign_out_path_for(resource)
    if resource == :corporate_user
      new_corporate_user_session_path
    else
      root_path
    end
  end
end
