# frozen_string_literal: true

class Users::SessionsController < ApplicationController
  include Users::SessionsHelper
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user
      reset_session
      user_log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination' # rubocop:disable Rails/I18nLocaleTexts
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    user_log_out
    redirect_to users_sign_in_url, status: :see_other
  end
end
