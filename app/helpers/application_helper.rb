module ApplicationHelper
  def title(page_title="MyApp")
    content_for(:title) {page_title.to_s}
  end

  def show_title?
    @show_title
  end


end

