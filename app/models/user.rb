# frozen_string_literal: true

class User < ApplicationRecord
  validates :first_name, presence: true
  validates :middle_name, presence: true, allow_nil: true
  validates :last_name, presence: true
  validates :employee_id, presence: true, uniqueness: true
  validates :email, email_format: { message: I18n.t('errors.messages.email_format') }, presence: true, uniqueness: true
  validates :slack_channel, presence: true, allow_nil: true

  # フルネームを取得する
  # @return [String] 姓 [ミドルネーム ]名
  def full_name
    middle_name.nil? ? "#{last_name} #{first_name}" : "#{last_name} #{middle_name} #{first_name}"
  end
end
