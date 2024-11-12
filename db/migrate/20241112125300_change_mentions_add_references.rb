class ChangeMentionsAddReferences < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :mentions, :reports, column: :mentioning_id
    add_foreign_key :mentions, :reports, column: :mentioned_id
  end
end
