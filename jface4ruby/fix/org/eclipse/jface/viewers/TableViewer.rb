class Org::Eclipse::Jface::Viewers::TableViewer
  def new_table_viewer_column(*styles, &block)
    TableViewerColumn.create self, styles, &block
  end

  def apply_structured_content_provider(&block)
    set_content_provider Class.new {
      include Org::Eclipse::Jface::Viewers::IStructuredContentProvider
      class_eval(&block)
    }.new
  end

  def apply_lazy_content_provider(&block)
    set_content_provider Class.new {
      include Org::Eclipse::Jface::Viewers::ILazyContentProvider
      class_eval(&block)
    }.new
  end
end
