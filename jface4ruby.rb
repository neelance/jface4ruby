require "rjava"
require "jre4ruby"
require "swt4ruby"

lib_path = "#{File.dirname(__FILE__)}/jface4ruby/lib"
fix_path = "#{File.dirname(__FILE__)}/jface4ruby/fix"
rep_path = "#{File.dirname(__FILE__)}/jface4ruby/rep"

add_class_loader { |package_path|
  dirs, names = list_paths "#{lib_path}/#{package_path}", "#{rep_path}/#{package_path}"
  
  dirs.each do |dir|
    import_package dir, package_path
  end
  
  names.each do |name|
    file_path = "#{package_path}/#{name}.rb"
    if File.exist?("#{rep_path}/#{file_path}")
      import_class name, "jface4ruby/rep/#{file_path}"
    elsif File.exist?("#{fix_path}/#{file_path}")
      import_class name, "jface4ruby/lib/#{file_path}", "jface4ruby/fix/#{file_path}"
    else
      import_class name, "jface4ruby/lib/#{file_path}"
    end
  end
}

class Swt4Ruby
  module NewWidgetMethods
    def new_checkbox_table_viewer(*styles, &block)
      Org::Eclipse::Jface::Viewers::CheckboxTableViewer.create find_composite, styles, &block
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
