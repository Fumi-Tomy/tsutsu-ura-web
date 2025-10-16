class StaticPagesController < ApplicationController
  def top
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
