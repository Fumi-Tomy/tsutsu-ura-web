class ChangeBodyToActionTextOnActionTextRichTexts < ActiveRecord::Migration[7.2]
  def up
    # --- PostgreSQL をお使いの場合 (基本的には不要ですが、念のため) ---
    change_column :action_text_rich_texts, :body, :text
  end
end
