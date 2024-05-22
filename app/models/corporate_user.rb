# frozen_string_literal: true

class CorporateUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :middle_name, presence: true, allow_nil: true
  validates :last_name, presence: true
  validates :employee_id, presence: true, uniqueness: true

  # フルネームを取得する
  # @return [String] 姓 [ミドルネーム ]名
  def full_name
    middle_name.nil? ? "#{last_name} #{first_name}" : "#{last_name} #{middle_name} #{first_name}"
  end
end
