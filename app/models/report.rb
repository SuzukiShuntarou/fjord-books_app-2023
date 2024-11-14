# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  has_many :mentioning_relationships, class_name: 'Mention',
                                      foreign_key: :mentioning_id,
                                      dependent: :destroy,
                                      inverse_of: :mentioning
  has_many :mentioning_reports, through: :mentioning_relationships, source: :mentioned

  has_many :mentioned_relationships, class_name: 'Mention',
                                     foreign_key: :mentioned_id,
                                     dependent: :destroy,
                                     inverse_of: :mentioned
  has_many :mentioned_reports, through: :mentioned_relationships, source: :mentioning

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def create_mentions
    mentioned_ids = extract_mentioned_ids(self)

    mentioning_relationships.destroy_all
    mentioned_ids.each do |id|
      mentioning_relationships.create!(mentioned_id: id)
    end
  end

  def extract_mentioned_ids(report)
    report.content.scan(%r{http://127\.0\.0\.1:3000/reports/(\d+)}).uniq.flatten
  end
end
