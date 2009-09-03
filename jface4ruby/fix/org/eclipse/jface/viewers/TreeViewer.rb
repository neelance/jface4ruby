class Org::Eclipse::Jface::Viewers::TreeViewer
  def apply_tree_content_provider(&block)
    set_content_provider Class.new {
      include Org::Eclipse::Jface::Viewers::ITreeContentProvider
      class_eval(&block)
    }.new
  end

  def apply_lazy_tree_content_provider(&block)
    set_content_provider Class.new {
      include Org::Eclipse::Jface::Viewers::ILazyTreeContentProvider
      class_eval(&block)
    }.new
  end

  def apply_lazy_tree_path_content_provider(&block)
    set_content_provider Class.new {
      include Org::Eclipse::Jface::Viewers::ILazyTreePathContentProvider
      class_eval(&block)
    }.new
  end
end
