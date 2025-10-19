class StaticPagesController < ApplicationController
  def top
    # 最新のブログ記事を3件取得 (N+1問題対策も実施)
    @latest_posts = Post.includes(:tags, :rich_text_body).order(created_at: :desc).limit(3)
  end

  def podcast
    add_breadcrumb "Top", root_path
    add_breadcrumb "Podcast", podcast_path
  end

  private

  def add_breadcrumbs_for_top
    add_breadcrumb "Top", root_path
  end

end
