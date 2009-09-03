class Org::Eclipse::Jface::Viewers::ColumnViewer
  def apply_label_provider(color_provider = false, font_provider = false, &block)
    set_label_provider Class.new {
      include Org::Eclipse::Jface::Viewers::ILabelProvider
      include Org::Eclipse::Jface::Viewers::IColorProvider if color_provider
      include Org::Eclipse::Jface::Viewers::IFontProvider if font_provider
      class_eval(&block)
    }.new
  end

  def apply_table_label_provider(color_provider = false, font_provider = false, &block)
    set_label_provider Class.new {
      include Org::Eclipse::Jface::Viewers::ITableLabelProvider
      include Org::Eclipse::Jface::Viewers::ITableColorProvider if color_provider
      include Org::Eclipse::Jface::Viewers::ITableFontProvider if font_provider
      class_eval(&block)
    }.new
  end
end
