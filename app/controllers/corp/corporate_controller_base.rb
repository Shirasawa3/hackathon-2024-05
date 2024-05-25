# frozen_string_literal: true

class Corp::CorporateControllerBase < ApplicationController
  before_action :redirect_if_guest

  private

  def redirect_if_guest
    unless current_corporate_user
      session[:previous_url] = request.fullpath
      redirect_to new_corporate_user_session_path
    end
  end
end
