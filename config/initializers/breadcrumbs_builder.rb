class Bootstrap5BreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    @context.content_tag(:nav, aria: { label: 'breadcrumb' }) do
      @context.content_tag(:ol, class: 'breadcrumb') do
        @elements.map do |element|
          render_element(element)
        end.join.html_safe
      end
    end
  end

  private

  def render_element(element)
    is_current = @context.current_page?(compute_path(element))
    options = element.options.merge(class: 'breadcrumb-item')
    options.merge!(aria: { current: 'page' }) if is_current

    @context.content_tag(:li, options) do
      @context.link_to_unless(is_current, compute_name(element), compute_path(element), element.options)
    end
  end
end