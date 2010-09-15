require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Hyperlink
  module DefaultHyperlinkPresenterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyleRange
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :RGB
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Preference, :IPreferenceStore
      include_const ::Org::Eclipse::Jface::Preference, :PreferenceConverter
      include_const ::Org::Eclipse::Jface::Util, :IPropertyChangeListener
      include_const ::Org::Eclipse::Jface::Util, :PropertyChangeEvent
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :DocumentEvent
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IDocumentListener
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextInputListener
      include_const ::Org::Eclipse::Jface::Text, :ITextPresentationListener
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension2
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension4
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextPresentation
    }
  end
  
  # The default hyperlink presenter underlines the
  # link and colors the line and the text with
  # the given color.
  # <p>
  # It can only be used together with the {@link HyperlinkManager#FIRST}
  # or the {@link HyperlinkManager#LONGEST_REGION_FIRST} hyperlink strategy.
  # </p>
  # 
  # @since 3.1
  class DefaultHyperlinkPresenter 
    include_class_members DefaultHyperlinkPresenterImports
    include IHyperlinkPresenter
    include IHyperlinkPresenterExtension
    include ITextPresentationListener
    include ITextInputListener
    include IDocumentListener
    include IPropertyChangeListener
    
    class_module.module_eval {
      # A named preference that holds the color used for hyperlinks.
      # <p>
      # Value is of type <code>String</code>. A RGB color value encoded as a string using class
      # <code>PreferenceConverter</code>.
      # </p>
      # 
      # @see org.eclipse.jface.resource.StringConverter
      # @see org.eclipse.jface.preference.PreferenceConverter
      const_set_lazy(:HYPERLINK_COLOR) { "hyperlinkColor" }
      const_attr_reader  :HYPERLINK_COLOR
      
      # $NON-NLS-1$
      # 
      # A named preference that holds the preference whether to use the native link color.
      # <p>
      # The preference value is of type <code>Boolean</code>.
      # </p>
      # 
      # @since 3.5
      const_set_lazy(:HYPERLINK_COLOR_SYSTEM_DEFAULT) { "hyperlinkColor.SystemDefault" }
      const_attr_reader  :HYPERLINK_COLOR_SYSTEM_DEFAULT
    }
    
    # $NON-NLS-1$
    # The text viewer.
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    # The link color.
    attr_accessor :f_color
    alias_method :attr_f_color, :f_color
    undef_method :f_color
    alias_method :attr_f_color=, :f_color=
    undef_method :f_color=
    
    # Tells whether to use native link color.
    # 
    # @since 3.5
    attr_accessor :f_is_using_native_link_color
    alias_method :attr_f_is_using_native_link_color, :f_is_using_native_link_color
    undef_method :f_is_using_native_link_color
    alias_method :attr_f_is_using_native_link_color=, :f_is_using_native_link_color=
    undef_method :f_is_using_native_link_color=
    
    # The link color specification. May be <code>null</code>.
    attr_accessor :f_rgb
    alias_method :attr_f_rgb, :f_rgb
    undef_method :f_rgb
    alias_method :attr_f_rgb=, :f_rgb=
    undef_method :f_rgb=
    
    # Tells whether to dispose the color on uninstall.
    attr_accessor :f_dispose_color
    alias_method :attr_f_dispose_color, :f_dispose_color
    undef_method :f_dispose_color
    alias_method :attr_f_dispose_color=, :f_dispose_color=
    undef_method :f_dispose_color=
    
    # The currently active region.
    attr_accessor :f_active_region
    alias_method :attr_f_active_region, :f_active_region
    undef_method :f_active_region
    alias_method :attr_f_active_region=, :f_active_region=
    undef_method :f_active_region=
    
    # The currently active style range as position.
    attr_accessor :f_remembered_position
    alias_method :attr_f_remembered_position, :f_remembered_position
    undef_method :f_remembered_position
    alias_method :attr_f_remembered_position=, :f_remembered_position=
    undef_method :f_remembered_position=
    
    # The optional preference store. May be <code>null</code>.
    attr_accessor :f_preference_store
    alias_method :attr_f_preference_store, :f_preference_store
    undef_method :f_preference_store
    alias_method :attr_f_preference_store=, :f_preference_store=
    undef_method :f_preference_store=
    
    typesig { [IPreferenceStore] }
    # Creates a new default hyperlink presenter which uses
    # {@link #HYPERLINK_COLOR} to read the color from the given preference store.
    # 
    # @param store the preference store
    def initialize(store)
      @f_text_viewer = nil
      @f_color = nil
      @f_is_using_native_link_color = false
      @f_rgb = nil
      @f_dispose_color = false
      @f_active_region = nil
      @f_remembered_position = nil
      @f_preference_store = nil
      @f_preference_store = store
      @f_dispose_color = true
    end
    
    typesig { [Color] }
    # Creates a new default hyperlink presenter.
    # 
    # @param color the hyperlink color or <code>null</code> if the existing text color should be
    # preserved; to be disposed by the caller
    def initialize(color)
      @f_text_viewer = nil
      @f_color = nil
      @f_is_using_native_link_color = false
      @f_rgb = nil
      @f_dispose_color = false
      @f_active_region = nil
      @f_remembered_position = nil
      @f_preference_store = nil
      @f_color = color
    end
    
    typesig { [RGB] }
    # Creates a new default hyperlink presenter.
    # 
    # @param color the hyperlink color or <code>null</code> if the existing text color should be
    # preserved
    def initialize(color)
      @f_text_viewer = nil
      @f_color = nil
      @f_is_using_native_link_color = false
      @f_rgb = nil
      @f_dispose_color = false
      @f_active_region = nil
      @f_remembered_position = nil
      @f_preference_store = nil
      @f_rgb = color
      @f_dispose_color = true
    end
    
    typesig { [] }
    # @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlinkControl#canShowMultipleHyperlinks()
    def can_show_multiple_hyperlinks
      return false
    end
    
    typesig { [Array.typed(IHyperlink)] }
    # @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlinkControl#activate(org.eclipse.jdt.internal.ui.javaeditor.IHyperlink[])
    def show_hyperlinks(hyperlinks)
      Assert.is_legal(!(hyperlinks).nil? && (hyperlinks.attr_length).equal?(1))
      highlight_region(hyperlinks[0].get_hyperlink_region)
    end
    
    typesig { [] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def can_hide_hyperlinks
      return true
    end
    
    typesig { [] }
    # @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlinkControl#deactivate()
    def hide_hyperlinks
      repair_representation
      @f_remembered_position = nil
    end
    
    typesig { [ITextViewer] }
    # @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlinkControl#install(org.eclipse.jface.text.ITextViewer)
    def install(text_viewer)
      Assert.is_not_null(text_viewer)
      @f_text_viewer = text_viewer
      @f_text_viewer.add_text_input_listener(self)
      if (@f_text_viewer.is_a?(ITextViewerExtension4))
        (@f_text_viewer).add_text_presentation_listener(self)
      end
      if (!(@f_preference_store).nil?)
        @f_is_using_native_link_color = @f_preference_store.get_boolean(HYPERLINK_COLOR_SYSTEM_DEFAULT)
        if (!@f_is_using_native_link_color)
          @f_color = create_color_from_preference_store
        end
        @f_preference_store.add_property_change_listener(self)
      else
        if (!(@f_rgb).nil?)
          text = @f_text_viewer.get_text_widget
          if (!(text).nil? && !text.is_disposed)
            @f_color = Color.new(text.get_display, @f_rgb)
          end
        end
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jdt.internal.ui.javaeditor.IHyperlinkControl#uninstall()
    def uninstall
      @f_text_viewer.remove_text_input_listener(self)
      document = @f_text_viewer.get_document
      if (!(document).nil?)
        document.remove_document_listener(self)
      end
      if (!(@f_color).nil?)
        if (@f_dispose_color)
          @f_color.dispose
        end
        @f_color = nil
      end
      if (@f_text_viewer.is_a?(ITextViewerExtension4))
        (@f_text_viewer).remove_text_presentation_listener(self)
      end
      @f_text_viewer = nil
      if (!(@f_preference_store).nil?)
        @f_preference_store.remove_property_change_listener(self)
        @f_preference_store = nil
      end
    end
    
    typesig { [Color] }
    # Sets the hyperlink foreground color.
    # 
    # @param color the hyperlink foreground color or <code>null</code> if the existing text color
    # should be preserved
    def set_color(color)
      Assert.is_not_null(@f_text_viewer)
      Assert.is_true((@f_preference_store).nil?, "Cannot set color if preference store is set") # $NON-NLS-1$
      if (!(@f_color).nil? && @f_dispose_color)
        @f_color.dispose
      end
      @f_color = color
    end
    
    typesig { [TextPresentation] }
    # @see org.eclipse.jface.text.ITextPresentationListener#applyTextPresentation(org.eclipse.jface.text.TextPresentation)
    def apply_text_presentation(text_presentation)
      if ((@f_active_region).nil?)
        return
      end
      region = text_presentation.get_extent
      if (@f_active_region.get_offset + @f_active_region.get_length >= region.get_offset && region.get_offset + region.get_length > @f_active_region.get_offset)
        color = nil
        if (!@f_is_using_native_link_color)
          color = @f_color
        end
        style_range = StyleRange.new(@f_active_region.get_offset, @f_active_region.get_length, color, nil)
        style_range.attr_underline_style = SWT::UNDERLINE_LINK
        style_range.attr_underline = true
        text_presentation.merge_style_range(style_range)
      end
    end
    
    typesig { [IRegion] }
    def highlight_region(region)
      if ((region == @f_active_region))
        return
      end
      repair_representation
      text = @f_text_viewer.get_text_widget
      if ((text).nil? || text.is_disposed)
        return
      end
      # Invalidate region ==> apply text presentation
      @f_active_region = region
      if (@f_text_viewer.is_a?(ITextViewerExtension2))
        (@f_text_viewer).invalidate_text_presentation(region.get_offset, region.get_length)
      else
        @f_text_viewer.invalidate_text_presentation
      end
    end
    
    typesig { [] }
    def repair_representation
      if ((@f_active_region).nil?)
        return
      end
      offset = @f_active_region.get_offset
      length = @f_active_region.get_length
      @f_active_region = nil
      # Invalidate ==> remove applied text presentation
      if (@f_text_viewer.is_a?(ITextViewerExtension2))
        (@f_text_viewer).invalidate_text_presentation(offset, length)
      else
        @f_text_viewer.invalidate_text_presentation
      end
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.IDocumentListener#documentAboutToBeChanged(org.eclipse.jface.text.DocumentEvent)
    def document_about_to_be_changed(event)
      if (!(@f_active_region).nil?)
        @f_remembered_position = Position.new(@f_active_region.get_offset, @f_active_region.get_length)
        begin
          event.get_document.add_position(@f_remembered_position)
        rescue BadLocationException => x
          @f_remembered_position = nil
        end
      end
    end
    
    typesig { [DocumentEvent] }
    # @see org.eclipse.jface.text.IDocumentListener#documentChanged(org.eclipse.jface.text.DocumentEvent)
    def document_changed(event)
      if (!(@f_remembered_position).nil?)
        if (!@f_remembered_position.is_deleted)
          event.get_document.remove_position(@f_remembered_position)
          @f_active_region = Region.new(@f_remembered_position.get_offset, @f_remembered_position.get_length)
        else
          @f_active_region = Region.new(event.get_offset, event.get_length)
        end
        @f_remembered_position = nil
        widget = @f_text_viewer.get_text_widget
        if (!(widget).nil? && !widget.is_disposed)
          widget.get_display.async_exec(Class.new(Runnable.class == Class ? Runnable : Object) do
            local_class_in DefaultHyperlinkPresenter
            include_class_members DefaultHyperlinkPresenter
            include Runnable if Runnable.class == Module
            
            typesig { [] }
            define_method :run do
              hide_hyperlinks
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
      end
    end
    
    typesig { [IDocument, IDocument] }
    # @see org.eclipse.jface.text.ITextInputListener#inputDocumentAboutToBeChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
    def input_document_about_to_be_changed(old_input, new_input)
      if ((old_input).nil?)
        return
      end
      hide_hyperlinks
      old_input.remove_document_listener(self)
    end
    
    typesig { [IDocument, IDocument] }
    # @see org.eclipse.jface.text.ITextInputListener#inputDocumentChanged(org.eclipse.jface.text.IDocument, org.eclipse.jface.text.IDocument)
    def input_document_changed(old_input, new_input)
      if ((new_input).nil?)
        return
      end
      new_input.add_document_listener(self)
    end
    
    typesig { [] }
    # Creates a color from the information stored in the given preference store.
    # 
    # @return the color or <code>null</code> if there is no such information available or i f the
    # text widget is not available
    def create_color_from_preference_store
      text_widget = @f_text_viewer.get_text_widget
      if ((text_widget).nil? || text_widget.is_disposed)
        return nil
      end
      rgb = nil
      if (@f_preference_store.contains(HYPERLINK_COLOR))
        if (@f_preference_store.is_default(HYPERLINK_COLOR))
          rgb = PreferenceConverter.get_default_color(@f_preference_store, HYPERLINK_COLOR)
        else
          rgb = PreferenceConverter.get_color(@f_preference_store, HYPERLINK_COLOR)
        end
        if (!(rgb).nil?)
          return Color.new(text_widget.get_display, rgb)
        end
      end
      return nil
    end
    
    typesig { [PropertyChangeEvent] }
    # @see org.eclipse.jface.util.IPropertyChangeListener#propertyChange(org.eclipse.jface.util.PropertyChangeEvent)
    def property_change(event)
      if ((HYPERLINK_COLOR == event.get_property))
        if (!(@f_color).nil? && @f_dispose_color)
          @f_color.dispose
        end
        @f_color = create_color_from_preference_store
        return
      end
      if ((HYPERLINK_COLOR_SYSTEM_DEFAULT == event.get_property))
        @f_is_using_native_link_color = @f_preference_store.get_boolean(HYPERLINK_COLOR_SYSTEM_DEFAULT)
        if (!@f_is_using_native_link_color && (@f_color).nil?)
          @f_color = create_color_from_preference_store
        end
        return
      end
    end
    
    private
    alias_method :initialize__default_hyperlink_presenter, :initialize
  end
  
end
