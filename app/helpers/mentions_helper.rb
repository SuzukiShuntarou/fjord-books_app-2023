# frozen_string_literal: true

module MentionsHelper
  REPORTS_URI = 'http://127.0.0.1:3000/reports/'

  def create_mentions(report)
    mentions = Mention.all
    mentioned_ids = extract_mentioned_ids(extract_urls(report))
    mentioned_ids.each do |id|
      Mention.create!(mentioning_id: report.id, mentioned_id: id) unless mentions.find_by(mentioning_id: report.id, mentioned_id: id)
    end
  end

  def destroy_mentions(report)
    mentioned_ids = extract_mentioned_ids(extract_urls(report))
    Mention.where(mentioning_id: report.id).where.not(mentioned_id: mentioned_ids).destroy_all
  end

  def extract_urls(report)
    report.content.scan(%r{http://127\.0\.0\.1:3000/reports/\d+}).to_s
  end

  def extract_mentioned_ids(content_url)
    urls = URI.extract(content_url, ['http']).uniq
    urls.map { |url| url.split(REPORTS_URI)[1] }
  end
end
