class Org::Eclipse::Jface::Text::TextViewer
  # Notifies that the selection has changed.
  def on_selection_changed(&block)
    add_post_selection_changed_listener Swt4Ruby::Listener.new(:selection_changed, &block)
  end

  # Called before the input document is replaced.
  def on_input_document_about_to_be_changed(&block)
    add_text_input_listener Swt4Ruby::Listener.new(:input_document_about_to_be_changed, &block)
  end

  # Called after the input document has been replaced.
  def on_input_document_changed(&block)
    add_text_input_listener Swt4Ruby::Listener.new(:input_document_changed, &block)
  end

  # The visual representation of a text viewer this listener is registered with has been changed.
  def on_text_changed(&block)
    add_text_listener Swt4Ruby::Listener.new(:text_changed, &block)
  end

  # This method is called when a text presentation is about to be applied to the text viewer. The receiver is allowed to change the text presentation during that call.
  def on_apply_text_presentation(&block)
    add_text_presentation_listener Swt4Ruby::Listener.new(:apply_text_presentation, &block)
  end

  # Informs about view port changes. The given vertical position is the new vertical scrolling offset measured in pixels.
  def on_viewport_changed(&block)
    add_viewport_listener Swt4Ruby::Listener.new(:viewport_changed, &block)
  end
end
