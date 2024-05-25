# frozen_string_literal: true

module ApplicationHelper
  def corporate_page?
    request.path_info.start_with?('/corp/')
  end
end
