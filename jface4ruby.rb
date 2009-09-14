require "rjava"
require "jre4ruby"
require "swt4ruby"

add_class_path "jface4ruby/rep"
add_class_path "jface4ruby/lib", "jface4ruby/fix"

class Swt4Ruby
  module NewWidgetMethods
    def new_checkbox_table_viewer(*styles, &block)
      style_mask = Swt4Ruby.replace_symbols(styles).inject(0) { |v, style| v | style }
      widget = Org::Eclipse::Jface::Viewers::CheckboxTableViewer.new_check_list(find_composite, style_mask)
      widget.instance_eval &block if block
      widget
    end

    def new_checkbox_tree_viewer(*styles, &block)
      Org::Eclipse::Jface::Viewers::CheckboxTreeViewer.create find_composite, styles, &block
    end

    def new_combo_viewer(*styles, &block)
      Org::Eclipse::Jface::Viewers::ComboViewer.create find_composite, styles, &block
    end

    def new_list_viewer(*styles, &block)
      Org::Eclipse::Jface::Viewers::ListViewer.create find_composite, styles, &block
    end

    def new_table_viewer(*styles, &block)
      Org::Eclipse::Jface::Viewers::TableViewer.create find_composite, styles, &block
    end

    def new_tree_viewer(*styles, &block)
      Org::Eclipse::Jface::Viewers::TreeViewer.create find_composite, styles, &block
    end

    def new_text_viewer(*styles, &block)
      Org::Eclipse::Jface::Text::TextViewer.create find_composite, styles, &block
    end
  end
end
