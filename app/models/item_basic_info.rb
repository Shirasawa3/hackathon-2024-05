# frozen_string_literal: true

class ItemBasicInfo < ApplicationRecord
  belongs_to :item_type
  has_many :lent_histories, dependent: :destroy

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
  def has_count? # rubocop:disable Naming/PredicateName
    !count.nil?
  end

  # tags を持つかどうかを表す値を取得する
  # @return [true, false]
  def has_tags? # rubocop:disable Naming/PredicateName
    !tags.nil?
  end

  private

  # count と tags のバリデーション
  def count_and_tags_are_exclusive
    errors.add(:count, I18n.t('errors.messages.count_and_tags_are_exclusive')) if !count.nil? && !tags.nil?
    errors.add(:count, I18n.t('errors.messages.count_or_tags_must_be_speficied')) if count.nil? && (tags.blank? || tags.empty?) # rubocop:disable Layout/LineLength
  end

  def tags_cannot_have_empty
    return unless tags

    errors.add(:tags, I18n.t('errors.messages.empty_string_cannot_be_included')) if tags.any?(&:blank?)
  end

  def tags_must_be_unique
    return unless tags

    errors.add(:tags, I18n.t('errors.messages.must_be_unique')) if tags.uniq.length != tags.length
  end
end