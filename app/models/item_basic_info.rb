# frozen_string_literal: true

class ItemBasicInfo < ApplicationRecord
  belongs_to :item_type

  validates :name, presence: true, uniqueness: { scope: :item_type_id }
  validate :count_and_tags_are_exclusive, :tags_cannot_have_empty, :tags_must_be_unique
  validates :count, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true

  enum status: {
    available: 0,
    in_lent: 1,
    out_of_service: 2,
    hidden: 3,
  }

  # count を持つかどうかを表す値を取得する
  # @return [true, false]
  def has_count?
    !count.nil?
  end

  # tags を持つかどうかを表す値を取得する
  # @return [true, false]
  def has_tags?
    !tags.nil?
  end

  private

  # count と tags のバリデーション
  def count_and_tags_are_exclusive
    # TODO: i18n対応
    errors.add(:count, 'とタグ一覧はどちらか一方のみ指定できます') if !count.nil? && !tags.nil?
    errors.add(:count, 'とタグ一覧どちらか一方を指定してください') if count.nil? && (tags.blank? || tags.empty?)
  end

  def tags_cannot_have_empty
    return unless tags

    # TODO: i18n対応
    errors.add(:tags, 'に空文字は含められません') if tags.any?(&:blank?)
  end

  def tags_must_be_unique
    return unless tags

    # TODO: i18n対応
    errors.add(:tags, 'は一意である必要があります') if tags.uniq.length != tags.length
  end
end
