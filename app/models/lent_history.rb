# frozen_string_literal: true

class LentHistory < ApplicationRecord
  belongs_to :user
  belongs_to :item_basic_info

  validates :tag, presence: true, allow_nil: true
  validates :lent_at, presence: true
  validates :period, presence: true
  validate :validate_period_and_returned_at

  # 現在貸出中のものを取得する
  # return [ActiveRecord::Relation<LentHistory>]
  scope :in_lent, -> { where(returned_at: nil) }

  # 返却済のものを取得する
  # return [ActiveRecord::Relation<LentHistory>]
  scope :not_in_lent, -> { where.not(returned_at: nil) }

  private

  def validate_period_and_returned_at
    return if lent_at.nil?

    errors.add(:period, I18n.t('errors.messages.equal_or_less_than_lent_at')) if !period.nil? && (period <= lent_at)
    errors.add(:period, I18n.t('errors.messages.equal_or_less_than_lent_at')) if !returned_at.nil? && (returned_at <= lent_at) # rubocop:disable Layout/LineLength
  end
end
