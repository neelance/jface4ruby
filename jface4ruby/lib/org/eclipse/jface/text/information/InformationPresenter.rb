require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Information
  module InformationPresenterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Information
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :ControlEvent
      include_const ::Org::Eclipse::Swt::Events, :ControlListener
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Swt::Widgets, :Display
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :AbstractInformationControlManager
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocumentExtension3
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :IViewportListener
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenKeeper
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenKeeperExtension
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenOwner
      include_const ::Org::Eclipse::Jface::Text, :IWidgetTokenOwnerExtension
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextUtilities
    }
  end
  
  # Standard implementation of <code>IInformationPresenter</code>.
  # This implementation extends <code>AbstractInformationControlManager</code>.
  # The information control is made visible on request by calling
  # {@link #showInformationControl(Rectangle)}.
  # <p>
  # Usually, clients instantiate this class and configure it before using it. The configuration
  # must be consistent: This means the used {@link org.eclipse.jface.text.IInformationControlCreator}
  # must create an information control expecting information in the same format the configured
  # {@link org.eclipse.jface.text.information.IInformationProvider}s  use to encode the information they provide.
  # </p>
  # 
  # @since 2.0
  class InformationPresenter < InformationPresenterImports.const_get :AbstractInformationControlManager
    include_class_members InformationPresenterImports
    overload_protected {
      include IInformationPresenter
      include IInformationPresenterExtension
      include IWidgetTokenKeeper
      include IWidgetTokenKeeperExtension
    }
    
    class_module.module_eval {
      # Priority of the info controls managed by this information presenter.
      # Default value: <code>5</code>.
      # 
      # @since 3.0
      # 
      # 
      # 5 as value has been chosen in order to beat the hovers of {@link org.eclipse.jface.text.TextViewerHoverManager}
      const_set_lazy(:WIDGET_PRIORITY) { 5 }
      const_attr_reader  :WIDGET_PRIORITY
      
      # Internal information control closer. Listens to several events issued by its subject control
      # and closes the information control when necessary.
      const_set_lazy(:Closer) { Class.new do
        extend LocalClass
        include_class_members InformationPresenter
        include IInformationControlCloser
        include ControlListener
        include MouseListener
        include FocusListener
        include IViewportListener
        include KeyListener
        
        # The subject control.
        attr_accessor :f_subject_control
        alias_method :attr_f_subject_control, :f_subject_control
        undef_method :f_subject_control
        alias_method :attr_f_subject_control=, :f_subject_control=
        undef_method :f_subject_control=
        
        # The information control.
        attr_accessor :f_information_control_to_close
        alias_method :attr_f_information_control_to_close, :f_information_control_to_close
        undef_method :f_information_control_to_close
        alias_method :attr_f_information_control_to_close=, :f_information_control_to_close=
        undef_method :f_information_control_to_close=
        
        # Indicates whether this closer is active.
        attr_accessor :f_is_active
        alias_method :attr_f_is_active, :f_is_active
        undef_method :f_is_active
        alias_method :attr_f_is_active=, :f_is_active=
        undef_method :f_is_active=
        
        typesig { [class_self::Control] }
        # @see IInformationControlCloser#setSubjectControl(Control)
        def set_subject_control(control)
          @f_subject_control = control
        end
        
        typesig { [class_self::IInformationControl] }
        # @see IInformationControlCloser#setInformationControl(IInformationControl)
        def set_information_control(control)
          @f_information_control_to_close = control
        end
        
        typesig { [class_self::Rectangle] }
        # @see IInformationControlCloser#start(Rectangle)
        def start(information_area)
          if (@f_is_active)
            return
          end
          @f_is_active = true
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.add_control_listener(self)
            @f_subject_control.add_mouse_listener(self)
            @f_subject_control.add_focus_listener(self)
            @f_subject_control.add_key_listener(self)
          end
          if (!(@f_information_control_to_close).nil?)
            @f_information_control_to_close.add_focus_listener(self)
          end
          self.attr_f_text_viewer.add_viewport_listener(self)
        end
        
        typesig { [] }
        # @see IInformationControlCloser#stop()
        def stop
          if (!@f_is_active)
            return
          end
          @f_is_active = false
          self.attr_f_text_viewer.remove_viewport_listener(self)
          if (!(@f_information_control_to_close).nil?)
            @f_information_control_to_close.remove_focus_listener(self)
          end
          if (!(@f_subject_control).nil? && !@f_subject_control.is_disposed)
            @f_subject_control.remove_control_listener(self)
            @f_subject_control.remove_mouse_listener(self)
            @f_subject_control.remove_focus_listener(self)
            @f_subject_control.remove_key_listener(self)
          end
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlResized(ControlEvent)
        def control_resized(e)
          hide_information_control
        end
        
        typesig { [class_self::ControlEvent] }
        # @see ControlListener#controlMoved(ControlEvent)
        def control_moved(e)
          hide_information_control
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDown(MouseEvent)
        def mouse_down(e)
          hide_information_control
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseUp(MouseEvent)
        def mouse_up(e)
        end
        
        typesig { [class_self::MouseEvent] }
        # @see MouseListener#mouseDoubleClick(MouseEvent)
        def mouse_double_click(e)
          hide_information_control
        end
        
        typesig { [class_self::FocusEvent] }
        # @see FocusListener#focusGained(FocusEvent)
        def focus_gained(e)
        end
        
        typesig { [class_self::FocusEvent] }
        # @see FocusListener#focusLost(FocusEvent)
        def focus_lost(e)
          d = @f_subject_control.get_display
          d.async_exec(Class.new(self.class::Runnable.class == Class ? self.class::Runnable : Object) do
            extend LocalClass
            include_class_members Closer
            include class_self::Runnable if class_self::Runnable.class == Module
            
            typesig { [] }
            # Without the asyncExec, mouse clicks to the workbench window are swallowed.
            define_method :run do
              if ((self.attr_f_information_control_to_close).nil? || !self.attr_f_information_control_to_close.is_focus_control)
                hide_information_control
              end
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        
        typesig { [::Java::Int] }
        # @see IViewportListenerListener#viewportChanged(int)
        def viewport_changed(top_index)
          hide_information_control
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyPressed(KeyEvent)
        def key_pressed(e)
          hide_information_control
        end
        
        typesig { [class_self::KeyEvent] }
        # @see KeyListener#keyReleased(KeyEvent)
        def key_released(e)
        end
        
        typesig { [] }
        def initialize
          @f_subject_control = nil
          @f_information_control_to_close = nil
          @f_is_active = false
        end
        
        private
        alias_method :initialize__closer, :initialize
      end }
    }
    
    # The text viewer this information presenter works on
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    # The map of <code>IInformationProvider</code> objects
    attr_accessor :f_providers
    alias_method :attr_f_providers, :f_providers
    undef_method :f_providers
    alias_method :attr_f_providers=, :f_providers=
    undef_method :f_providers=
    
    # The offset to override selection.
    attr_accessor :f_offset
    alias_method :attr_f_offset, :f_offset
    undef_method :f_offset
    alias_method :attr_f_offset=, :f_offset=
    undef_method :f_offset=
    
    # The document partitioning for this information presenter.
    # @since 3.0
    attr_accessor :f_partitioning
    alias_method :attr_f_partitioning, :f_partitioning
    undef_method :f_partitioning
    alias_method :attr_f_partitioning=, :f_partitioning=
    undef_method :f_partitioning=
    
    typesig { [IInformationControlCreator] }
    # Creates a new information presenter that uses the given information control creator.
    # The presenter is not installed on any text viewer yet. By default, an information
    # control closer is set that closes the information control in the event of key strokes,
    # resizing, moves, focus changes, mouse clicks, and disposal - all of those applied to
    # the information control's parent control. Also, the setup ensures that the information
    # control when made visible will request the focus. By default, the default document
    # partitioning {@link IDocumentExtension3#DEFAULT_PARTITIONING} is used.
    # 
    # @param creator the information control creator to be used
    def initialize(creator)
      @f_text_viewer = nil
      @f_providers = nil
      @f_offset = 0
      @f_partitioning = nil
      super(creator)
      @f_offset = -1
      set_closer(Closer.new_local(self))
      takes_focus_when_visible(true)
      @f_partitioning = RJava.cast_to_string(IDocumentExtension3::DEFAULT_PARTITIONING)
    end
    
    typesig { [String] }
    # Sets the document partitioning to be used by this information presenter.
    # 
    # @param partitioning the document partitioning to be used by this information presenter
    # @since 3.0
    def set_document_partitioning(partitioning)
      Assert.is_not_null(partitioning)
      @f_partitioning = partitioning
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.information.IInformationPresenterExtension#getDocumentPartitioning()
    # @since 3.0
    def get_document_partitioning
      return @f_partitioning
    end
    
    typesig { [IInformationProvider, String] }
    # Registers a given information provider for a particular content type.
    # If there is already a provider registered for this type, the new provider
    # is registered instead of the old one.
    # 
    # @param provider the information provider to register, or <code>null</code> to remove an existing one
    # @param contentType the content type under which to register
    def set_information_provider(provider, content_type)
      Assert.is_not_null(content_type)
      if ((@f_providers).nil?)
        @f_providers = HashMap.new
      end
      if ((provider).nil?)
        @f_providers.remove(content_type)
      else
        @f_providers.put(content_type, provider)
      end
    end
    
    typesig { [String] }
    # @see IInformationPresenter#getInformationProvider(String)
    def get_information_provider(content_type)
      if ((@f_providers).nil?)
        return nil
      end
      return @f_providers.get(content_type)
    end
    
    typesig { [::Java::Int] }
    # Sets a offset to override the selection. Setting the value to <code>-1</code> will disable
    # overriding.
    # 
    # @param offset the offset to override selection or <code>-1</code>
    def set_offset(offset)
      @f_offset = offset
    end
    
    typesig { [] }
    # @see AbstractInformationControlManager#computeInformation()
    def compute_information
      offset = @f_offset < 0 ? @f_text_viewer.get_selected_range.attr_x : @f_offset
      if ((offset).equal?(-1))
        return
      end
      @f_offset = -1
      provider = nil
      begin
        content_type = TextUtilities.get_content_type(@f_text_viewer.get_document, get_document_partitioning, offset, true)
        provider = get_information_provider(content_type)
      rescue BadLocationException => x
      end
      if ((provider).nil?)
        return
      end
      subject = provider.get_subject(@f_text_viewer, offset)
      if ((subject).nil?)
        return
      end
      info = nil
      if (provider.is_a?(IInformationProviderExtension))
        extension = provider
        info = extension.get_information2(@f_text_viewer, subject)
      else
        # backward compatibility code
        info = provider.get_information(@f_text_viewer, subject)
      end
      if (provider.is_a?(IInformationProviderExtension2))
        set_custom_information_control_creator((provider).get_information_presenter_control_creator)
      else
        set_custom_information_control_creator(nil)
      end
      set_information(info, compute_area(subject))
    end
    
    typesig { [IRegion] }
    # Determines the graphical area covered by the given text region.
    # 
    # @param region the region whose graphical extend must be computed
    # @return the graphical extend of the given region
    def compute_area(region)
      start = 0
      end_ = 0
      widget_region = model_range2widget_range(region)
      if (!(widget_region).nil?)
        start = widget_region.get_offset
        end_ = widget_region.get_offset + widget_region.get_length
      end
      styled_text = @f_text_viewer.get_text_widget
      bounds = nil
      if (end_ > 0 && start < end_)
        bounds = styled_text.get_text_bounds(start, end_ - 1)
      else
        loc = styled_text.get_location_at_offset(start)
        bounds = Rectangle.new(loc.attr_x, loc.attr_y, 0, styled_text.get_line_height(start))
      end
      return bounds
    end
    
    typesig { [IRegion] }
    # Translated the given range in the viewer's document into the corresponding
    # range of the viewer's widget.
    # 
    # @param region the range in the viewer's document
    # @return the corresponding widget range
    # @since 2.1
    def model_range2widget_range(region)
      if (@f_text_viewer.is_a?(ITextViewerExtension5))
        extension = @f_text_viewer
        return extension.model_range2widget_range(region)
      end
      visible_region = @f_text_viewer.get_visible_region
      start = region.get_offset - visible_region.get_offset
      end_ = start + region.get_length
      if (end_ > visible_region.get_length)
        end_ = visible_region.get_length
      end
      return Region.new(start, end_ - start)
    end
    
    typesig { [ITextViewer] }
    # @see IInformationPresenter#install(ITextViewer)
    def install(text_viewer)
      @f_text_viewer = text_viewer
      install(@f_text_viewer.get_text_widget)
    end
    
    typesig { [] }
    # @see IInformationPresenter#uninstall()
    def uninstall
      dispose
    end
    
    typesig { [Rectangle] }
    # @see AbstractInformationControlManager#showInformationControl(Rectangle)
    def show_information_control(subject_area)
      if (@f_text_viewer.is_a?(IWidgetTokenOwnerExtension) && @f_text_viewer.is_a?(IWidgetTokenOwner))
        extension = @f_text_viewer
        if (extension.request_widget_token(self, WIDGET_PRIORITY))
          super(subject_area)
        end
      else
        if (@f_text_viewer.is_a?(IWidgetTokenOwner))
          owner = @f_text_viewer
          if (owner.request_widget_token(self))
            super(subject_area)
          end
        else
          super(subject_area)
        end
      end
    end
    
    typesig { [] }
    # @see AbstractInformationControlManager#hideInformationControl()
    def hide_information_control
      begin
        super
      ensure
        if (@f_text_viewer.is_a?(IWidgetTokenOwner))
          owner = @f_text_viewer
          owner.release_widget_token(self)
        end
      end
    end
    
    typesig { [] }
    # @see AbstractInformationControlManager#handleInformationControlDisposed()
    def handle_information_control_disposed
      begin
        super
      ensure
        if (@f_text_viewer.is_a?(IWidgetTokenOwner))
          owner = @f_text_viewer
          owner.release_widget_token(self)
        end
      end
    end
    
    typesig { [IWidgetTokenOwner] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeper#requestWidgetToken(IWidgetTokenOwner)
    def request_widget_token(owner)
      return false
    end
    
    typesig { [IWidgetTokenOwner, ::Java::Int] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(org.eclipse.jface.text.IWidgetTokenOwner, int)
    # @since 3.0
    def request_widget_token(owner, priority)
      return false
    end
    
    typesig { [IWidgetTokenOwner] }
    # @see org.eclipse.jface.text.IWidgetTokenKeeperExtension#setFocus(org.eclipse.jface.text.IWidgetTokenOwner)
    # @since 3.0
    def set_focus(owner)
      return false
    end
    
    private
    alias_method :initialize__information_presenter, :initialize
  end
  
end
