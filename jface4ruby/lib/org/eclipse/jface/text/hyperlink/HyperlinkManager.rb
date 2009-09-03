require "rjava"

# Copyright (c) 2000, 2009 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
# Steffen Pingel <steffen.pingel@tasktop.com> (Tasktop Technologies Inc.) - [navigation] hyperlink decoration is not erased when mouse is moved out of Text widget - https://bugs.eclipse.org/bugs/show_bug.cgi?id=100278
module Org::Eclipse::Jface::Text::Hyperlink
  module HyperlinkManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Hyperlink
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Org::Eclipse::Swt, :SWT
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :FocusEvent
      include_const ::Org::Eclipse::Swt::Events, :FocusListener
      include_const ::Org::Eclipse::Swt::Events, :KeyEvent
      include_const ::Org::Eclipse::Swt::Events, :KeyListener
      include_const ::Org::Eclipse::Swt::Events, :MouseEvent
      include_const ::Org::Eclipse::Swt::Events, :MouseListener
      include_const ::Org::Eclipse::Swt::Events, :MouseMoveListener
      include_const ::Org::Eclipse::Swt::Events, :MouseTrackListener
      include_const ::Org::Eclipse::Swt::Widgets, :Event
      include_const ::Org::Eclipse::Swt::Widgets, :Listener
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextListener
      include_const ::Org::Eclipse::Jface::Text, :ITextViewer
      include_const ::Org::Eclipse::Jface::Text, :JFaceTextUtil
      include_const ::Org::Eclipse::Jface::Text, :Region
      include_const ::Org::Eclipse::Jface::Text, :TextEvent
    }
  end
  
  # Default implementation of a hyperlink manager.
  # 
  # @since 3.1
  class HyperlinkManager 
    include_class_members HyperlinkManagerImports
    include ITextListener
    include Listener
    include KeyListener
    include MouseListener
    include MouseMoveListener
    include FocusListener
    include MouseTrackListener
    
    class_module.module_eval {
      # Detection strategy.
      const_set_lazy(:DETECTION_STRATEGY) { Class.new do
        include_class_members HyperlinkManager
        
        attr_accessor :f_name
        alias_method :attr_f_name, :f_name
        undef_method :f_name
        alias_method :attr_f_name=, :f_name=
        undef_method :f_name=
        
        typesig { [String] }
        def initialize(name)
          @f_name = nil
          @f_name = name
        end
        
        typesig { [] }
        # @see java.lang.Object#toString()
        def to_s
          return @f_name
        end
        
        private
        alias_method :initialize__detection_strategy, :initialize
      end }
      
      # The first detected hyperlink is passed to the
      # hyperlink presenter and no further detector
      # is consulted.
      const_set_lazy(:FIRST) { DETECTION_STRATEGY.new("first") }
      const_attr_reader  :FIRST
      
      # $NON-NLS-1$
      # 
      # All detected hyperlinks from all detectors are collected
      # and passed to the hyperlink presenter.
      # <p>
      # This strategy is only allowed if {@link IHyperlinkPresenter#canShowMultipleHyperlinks()}
      # returns <code>true</code>.
      # </p>
      const_set_lazy(:ALL) { DETECTION_STRATEGY.new("all") }
      const_attr_reader  :ALL
      
      # $NON-NLS-1$
      # 
      # All detected hyperlinks from all detectors are collected
      # and all those with the longest region are passed to the
      # hyperlink presenter.
      # <p>
      # This strategy is only allowed if {@link IHyperlinkPresenter#canShowMultipleHyperlinks()}
      # returns <code>true</code>.
      # </p>
      const_set_lazy(:LONGEST_REGION_ALL) { DETECTION_STRATEGY.new("all with same longest region") }
      const_attr_reader  :LONGEST_REGION_ALL
      
      # $NON-NLS-1$
      # 
      # All detected hyperlinks from all detectors are collected
      # and form all those with the longest region only the first
      # one is passed to the hyperlink presenter.
      const_set_lazy(:LONGEST_REGION_FIRST) { DETECTION_STRATEGY.new("first with longest region") }
      const_attr_reader  :LONGEST_REGION_FIRST
    }
    
    # $NON-NLS-1$
    # The text viewer on which this hyperlink manager works.
    attr_accessor :f_text_viewer
    alias_method :attr_f_text_viewer, :f_text_viewer
    undef_method :f_text_viewer
    alias_method :attr_f_text_viewer=, :f_text_viewer=
    undef_method :f_text_viewer=
    
    # The session is active.
    attr_accessor :f_active
    alias_method :attr_f_active, :f_active
    undef_method :f_active
    alias_method :attr_f_active=, :f_active=
    undef_method :f_active=
    
    # The key modifier mask.
    attr_accessor :f_hyperlink_state_mask
    alias_method :attr_f_hyperlink_state_mask, :f_hyperlink_state_mask
    undef_method :f_hyperlink_state_mask
    alias_method :attr_f_hyperlink_state_mask=, :f_hyperlink_state_mask=
    undef_method :f_hyperlink_state_mask=
    
    # The active key modifier mask.
    # @since 3.3
    attr_accessor :f_active_hyperlink_state_mask
    alias_method :attr_f_active_hyperlink_state_mask, :f_active_hyperlink_state_mask
    undef_method :f_active_hyperlink_state_mask
    alias_method :attr_f_active_hyperlink_state_mask=, :f_active_hyperlink_state_mask=
    undef_method :f_active_hyperlink_state_mask=
    
    # The active hyperlinks.
    attr_accessor :f_active_hyperlinks
    alias_method :attr_f_active_hyperlinks, :f_active_hyperlinks
    undef_method :f_active_hyperlinks
    alias_method :attr_f_active_hyperlinks=, :f_active_hyperlinks=
    undef_method :f_active_hyperlinks=
    
    # The hyperlink detectors.
    attr_accessor :f_hyperlink_detectors
    alias_method :attr_f_hyperlink_detectors, :f_hyperlink_detectors
    undef_method :f_hyperlink_detectors
    alias_method :attr_f_hyperlink_detectors=, :f_hyperlink_detectors=
    undef_method :f_hyperlink_detectors=
    
    # The hyperlink presenter.
    attr_accessor :f_hyperlink_presenter
    alias_method :attr_f_hyperlink_presenter, :f_hyperlink_presenter
    undef_method :f_hyperlink_presenter
    alias_method :attr_f_hyperlink_presenter=, :f_hyperlink_presenter=
    undef_method :f_hyperlink_presenter=
    
    # The detection strategy.
    attr_accessor :f_detection_strategy
    alias_method :attr_f_detection_strategy, :f_detection_strategy
    undef_method :f_detection_strategy
    alias_method :attr_f_detection_strategy=, :f_detection_strategy=
    undef_method :f_detection_strategy=
    
    typesig { [DETECTION_STRATEGY] }
    # Creates a new hyperlink manager.
    # 
    # @param detectionStrategy the detection strategy one of {{@link #ALL}, {@link #FIRST}, {@link #LONGEST_REGION_ALL}, {@link #LONGEST_REGION_FIRST}}
    def initialize(detection_strategy)
      @f_text_viewer = nil
      @f_active = false
      @f_hyperlink_state_mask = 0
      @f_active_hyperlink_state_mask = 0
      @f_active_hyperlinks = nil
      @f_hyperlink_detectors = nil
      @f_hyperlink_presenter = nil
      @f_detection_strategy = nil
      Assert.is_not_null(detection_strategy)
      @f_detection_strategy = detection_strategy
    end
    
    typesig { [ITextViewer, IHyperlinkPresenter, Array.typed(IHyperlinkDetector), ::Java::Int] }
    # Installs this hyperlink manager with the given arguments.
    # 
    # @param textViewer the text viewer
    # @param hyperlinkPresenter the hyperlink presenter
    # @param hyperlinkDetectors the array of hyperlink detectors, must not be empty
    # @param eventStateMask the SWT event state mask to activate hyperlink mode
    def install(text_viewer, hyperlink_presenter, hyperlink_detectors, event_state_mask)
      Assert.is_not_null(text_viewer)
      Assert.is_not_null(hyperlink_presenter)
      @f_text_viewer = text_viewer
      @f_hyperlink_presenter = hyperlink_presenter
      Assert.is_legal(@f_hyperlink_presenter.can_show_multiple_hyperlinks || (@f_detection_strategy).equal?(FIRST) || (@f_detection_strategy).equal?(LONGEST_REGION_FIRST))
      set_hyperlink_detectors(hyperlink_detectors)
      set_hyperlink_state_mask(event_state_mask)
      text = @f_text_viewer.get_text_widget
      if ((text).nil? || text.is_disposed)
        return
      end
      text.get_display.add_filter(SWT::KeyUp, self)
      text.add_key_listener(self)
      text.add_mouse_listener(self)
      text.add_mouse_move_listener(self)
      text.add_focus_listener(self)
      text.add_mouse_track_listener(self)
      @f_text_viewer.add_text_listener(self)
      @f_hyperlink_presenter.install(@f_text_viewer)
    end
    
    typesig { [Array.typed(IHyperlinkDetector)] }
    # Sets the hyperlink detectors for this hyperlink manager.
    # <p>
    # It is allowed to call this method after this
    # hyperlink manger has been installed.
    # </p>
    # 
    # @param hyperlinkDetectors and array of hyperlink detectors, must not be empty
    def set_hyperlink_detectors(hyperlink_detectors)
      Assert.is_true(!(hyperlink_detectors).nil? && hyperlink_detectors.attr_length > 0)
      if ((@f_hyperlink_detectors).nil?)
        @f_hyperlink_detectors = hyperlink_detectors
      else
        synchronized((@f_hyperlink_detectors)) do
          @f_hyperlink_detectors = hyperlink_detectors
        end
      end
    end
    
    typesig { [::Java::Int] }
    # Sets the SWT event state mask which in combination
    # with the left mouse button triggers the hyperlink mode.
    # <p>
    # It is allowed to call this method after this
    # hyperlink manger has been installed.
    # </p>
    # 
    # @param eventStateMask the SWT event state mask to activate hyperlink mode
    def set_hyperlink_state_mask(event_state_mask)
      @f_hyperlink_state_mask = event_state_mask
    end
    
    typesig { [] }
    # Uninstalls this hyperlink manager.
    def uninstall
      deactivate
      text = @f_text_viewer.get_text_widget
      if (!(text).nil? && !text.is_disposed)
        text.remove_key_listener(self)
        text.get_display.remove_filter(SWT::KeyUp, self)
        text.remove_mouse_listener(self)
        text.remove_mouse_move_listener(self)
        text.remove_focus_listener(self)
        text.remove_mouse_track_listener(self)
      end
      @f_text_viewer.remove_text_listener(self)
      @f_hyperlink_presenter.uninstall
      @f_hyperlink_presenter = nil
      @f_text_viewer = nil
      @f_hyperlink_detectors = nil
    end
    
    typesig { [] }
    # Deactivates the currently shown hyperlinks.
    def deactivate
      @f_hyperlink_presenter.hide_hyperlinks
      @f_active = false
    end
    
    typesig { [] }
    # Finds hyperlinks at the current offset.
    # 
    # @return the hyperlinks or <code>null</code> if none.
    def find_hyperlinks
      offset = get_current_text_offset
      if ((offset).equal?(-1))
        return nil
      end
      can_show_multiple_hyperlinks_ = @f_hyperlink_presenter.can_show_multiple_hyperlinks
      region = Region.new(offset, 0)
      all_hyperlinks = ArrayList.new(@f_hyperlink_detectors.attr_length * 2)
      synchronized((@f_hyperlink_detectors)) do
        i = 0
        length = @f_hyperlink_detectors.attr_length
        while i < length
          detector = @f_hyperlink_detectors[i]
          if ((detector).nil?)
            i += 1
            next
          end
          if (detector.is_a?(IHyperlinkDetectorExtension2))
            state_mask = (detector).get_state_mask
            if (!(state_mask).equal?(-1) && !(state_mask).equal?(@f_active_hyperlink_state_mask))
              i += 1
              next
            else
              if ((state_mask).equal?(-1) && !(@f_active_hyperlink_state_mask).equal?(@f_hyperlink_state_mask))
                i += 1
                next
              end
            end
          else
            if (!(@f_active_hyperlink_state_mask).equal?(@f_hyperlink_state_mask))
              i += 1
              next
            end
          end
          hyperlinks = detector.detect_hyperlinks(@f_text_viewer, region, can_show_multiple_hyperlinks_)
          if ((hyperlinks).nil?)
            i += 1
            next
          end
          Assert.is_legal(hyperlinks.attr_length > 0)
          if ((@f_detection_strategy).equal?(FIRST))
            if ((hyperlinks.attr_length).equal?(1))
              return hyperlinks
            end
            return Array.typed(IHyperlink).new([hyperlinks[0]])
          end
          all_hyperlinks.add_all(Arrays.as_list(hyperlinks))
          i += 1
        end
      end
      if (all_hyperlinks.is_empty)
        return nil
      end
      if (!(@f_detection_strategy).equal?(ALL))
        max_length = compute_longest_hyperlink_length(all_hyperlinks)
        iter = ArrayList.new(all_hyperlinks).iterator
        while (iter.has_next)
          hyperlink = iter.next_
          if (hyperlink.get_hyperlink_region.get_length < max_length)
            all_hyperlinks.remove(hyperlink)
          end
        end
      end
      if ((@f_detection_strategy).equal?(LONGEST_REGION_FIRST))
        return Array.typed(IHyperlink).new([all_hyperlinks.get(0)])
      end
      return all_hyperlinks.to_array(Array.typed(IHyperlink).new(all_hyperlinks.size) { nil })
    end
    
    typesig { [JavaList] }
    # Computes the length of the longest detected hyperlink.
    # 
    # @param hyperlinks the list of hyperlinks
    # @return the length of the longest detected
    def compute_longest_hyperlink_length(hyperlinks)
      Assert.is_legal(!(hyperlinks).nil? && !hyperlinks.is_empty)
      iter = hyperlinks.iterator
      length = JavaInteger::MIN_VALUE
      while (iter.has_next)
        region = (iter.next_).get_hyperlink_region
        if (region.get_length < length)
          next
        end
        length = region.get_length
      end
      return length
    end
    
    typesig { [] }
    # Returns the current text offset.
    # 
    # @return the current text offset
    def get_current_text_offset
      return JFaceTextUtil.get_offset_for_cursor_location(@f_text_viewer)
    end
    
    typesig { [KeyEvent] }
    # @see org.eclipse.swt.events.KeyListener#keyPressed(org.eclipse.swt.events.KeyEvent)
    def key_pressed(event)
      if (@f_active)
        deactivate
        return
      end
      if (!is_registered_state_mask(event.attr_key_code))
        deactivate
        return
      end
      @f_active = true
      @f_active_hyperlink_state_mask = event.attr_key_code
      # removed for #25871 (hyperlinks could interact with typing)
      # 
      # ITextViewer viewer= getSourceViewer();
      # if (viewer == null)
      # return;
      # 
      # IRegion region= getCurrentTextRegion(viewer);
      # if (region == null)
      # return;
      # 
      # highlightRegion(viewer, region);
      # activateCursor(viewer);
    end
    
    typesig { [KeyEvent] }
    # @see org.eclipse.swt.events.KeyListener#keyReleased(org.eclipse.swt.events.KeyEvent)
    def key_released(event)
    end
    
    typesig { [MouseEvent] }
    # @see org.eclipse.swt.events.MouseListener#mouseDoubleClick(org.eclipse.swt.events.MouseEvent)
    def mouse_double_click(e)
    end
    
    typesig { [MouseEvent] }
    # @see org.eclipse.swt.events.MouseListener#mouseDown(org.eclipse.swt.events.MouseEvent)
    def mouse_down(event)
      if (!@f_active)
        return
      end
      if (!(event.attr_state_mask).equal?(@f_active_hyperlink_state_mask))
        deactivate
        return
      end
      if (!(event.attr_button).equal?(1))
        deactivate
        return
      end
    end
    
    typesig { [MouseEvent] }
    # @see org.eclipse.swt.events.MouseListener#mouseUp(org.eclipse.swt.events.MouseEvent)
    def mouse_up(e)
      if (!@f_active)
        @f_active_hyperlinks = nil
        return
      end
      if (!(e.attr_button).equal?(1))
        @f_active_hyperlinks = nil
      end
      deactivate
      if (!(@f_active_hyperlinks).nil?)
        @f_active_hyperlinks[0].open
      end
    end
    
    typesig { [MouseEvent] }
    # @see org.eclipse.swt.events.MouseMoveListener#mouseMove(org.eclipse.swt.events.MouseEvent)
    def mouse_move(event)
      if (@f_hyperlink_presenter.is_a?(IHyperlinkPresenterExtension))
        if (!(@f_hyperlink_presenter).can_hide_hyperlinks)
          return
        end
      end
      if (!is_registered_state_mask(event.attr_state_mask))
        if (@f_active)
          deactivate
        end
        return
      end
      @f_active = true
      @f_active_hyperlink_state_mask = event.attr_state_mask
      text = @f_text_viewer.get_text_widget
      if ((text).nil? || text.is_disposed)
        deactivate
        return
      end
      if (!((event.attr_state_mask & SWT::BUTTON1)).equal?(0) && !(text.get_selection_count).equal?(0))
        deactivate
        return
      end
      @f_active_hyperlinks = find_hyperlinks
      if ((@f_active_hyperlinks).nil? || (@f_active_hyperlinks.attr_length).equal?(0))
        @f_hyperlink_presenter.hide_hyperlinks
        return
      end
      @f_hyperlink_presenter.show_hyperlinks(@f_active_hyperlinks)
    end
    
    typesig { [::Java::Int] }
    # Checks whether the given state mask is registered.
    # 
    # @param stateMask the state mask
    # @return <code>true</code> if a detector is registered for the given state mask
    # @since 3.3
    def is_registered_state_mask(state_mask)
      if ((state_mask).equal?(@f_hyperlink_state_mask))
        return true
      end
      synchronized((@f_hyperlink_detectors)) do
        i = 0
        while i < @f_hyperlink_detectors.attr_length
          if (@f_hyperlink_detectors[i].is_a?(IHyperlinkDetectorExtension2))
            if ((state_mask).equal?((@f_hyperlink_detectors[i]).get_state_mask))
              return true
            end
          end
          i += 1
        end
      end
      return false
    end
    
    typesig { [FocusEvent] }
    # @see org.eclipse.swt.events.FocusListener#focusGained(org.eclipse.swt.events.FocusEvent)
    def focus_gained(e)
    end
    
    typesig { [FocusEvent] }
    # @see org.eclipse.swt.events.FocusListener#focusLost(org.eclipse.swt.events.FocusEvent)
    def focus_lost(event)
      deactivate
    end
    
    typesig { [Event] }
    # @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
    # @since 3.2
    def handle_event(event)
      # key up
      deactivate
    end
    
    typesig { [TextEvent] }
    # @see org.eclipse.jface.text.ITextListener#textChanged(TextEvent)
    # @since 3.2
    def text_changed(event)
      if (!(event.get_document_event).nil?)
        deactivate
      end
    end
    
    typesig { [MouseEvent] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def mouse_exit(e)
      if (@f_hyperlink_presenter.is_a?(IHyperlinkPresenterExtension))
        if (!(@f_hyperlink_presenter).can_hide_hyperlinks)
          return
        end
      end
      deactivate
    end
    
    typesig { [MouseEvent] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def mouse_enter(e)
    end
    
    typesig { [MouseEvent] }
    # {@inheritDoc}
    # 
    # @since 3.4
    def mouse_hover(e)
    end
    
    private
    alias_method :initialize__hyperlink_manager, :initialize
  end
  
end
