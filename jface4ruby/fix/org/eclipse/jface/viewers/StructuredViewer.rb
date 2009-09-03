class Org::Eclipse::Jface::Viewers::StructuredViewer
  # Notifies of a double click.
  def on_double_click(&block)
    add_double_click_listener Swt4Ruby::Listener.new(:double_click, &block)
  end

  # Notifies of an open event.
  def on_open(&block)
    add_open_listener Swt4Ruby::Listener.new(:open, &block)
  end
end
