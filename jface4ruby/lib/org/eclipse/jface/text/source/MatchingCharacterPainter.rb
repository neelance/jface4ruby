require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Source
  module MatchingCharacterPainterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Events, :PaintEvent
      include_const ::Org::Eclipse::Swt::Events, :PaintListener
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Jface::Text, :BadLocationException
      include_const ::Org::Eclipse::Jface::Text, :IDocument
      include_const ::Org::Eclipse::Jface::Text, :IPaintPositionManager
      include_const ::Org::Eclipse::Jface::Text, :IPainter
      include_const ::Org::Eclipse::Jface::Text, :IRegion
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension5
      include_const ::Org::Eclipse::Jface::Text, :Position
      include_const ::Org::Eclipse::Jface::Text, :Region
    }
  end
  
  # Highlights the peer character matching the character near the caret position.
  # This painter can be configured with an
  # {@link org.eclipse.jface.text.source.ICharacterPairMatcher}.
  # <p>
  # Clients instantiate and configure object of this class.</p>
  # 
  # @since 2.1
  class MatchingCharacterPainter 
    include_class_members MatchingCharacterPainterImports
    include IPainter
    include PaintListener
    
    # Indicates whether this painter is active
    attr_accessor :f_is_active
    alias_method :attr_f_is_active, :f_is_active
    undef_method :f_is_active
    alias_method :attr_f_is_active=, :f_is_active=
    undef_method :f_is_active=
    
    # The source viewer this painter is associated with
    attr_accessor :f_source_viewer
    alias_method :attr_f_source_viewer, :f_source_viewer
    undef_method :f_source_viewer
    alias_method :attr_f_source_viewer=, :f_source_viewer=
    undef_method :f_source_viewer=
    
    # The viewer's widget
    attr_accessor :f_text_widget
    alias_method :attr_f_text_widget, :f_text_widget
    undef_method :f_text_widget
    alias_method :attr_f_text_widget=, :f_text_widget=
    undef_method :f_text_widget=
    
    # The color in which to highlight the peer character
    attr_accessor :f_color
    alias_method :attr_f_color, :f_color
    undef_method :f_color
    alias_method :attr_f_color=, :f_color=
    undef_method :f_color=
    
    # The paint position manager
    attr_accessor :f_paint_position_manager
    alias_method :attr_f_paint_position_manager, :f_paint_position_manager
    undef_method :f_paint_position_manager
    alias_method :attr_f_paint_position_manager=, :f_paint_position_manager=
    undef_method :f_paint_position_manager=
    
    # The strategy for finding matching characters
    attr_accessor :f_matcher
    alias_method :attr_f_matcher, :f_matcher
    undef_method :f_matcher
    alias_method :attr_f_matcher=, :f_matcher=
    undef_method :f_matcher=
    
    # The position tracking the matching characters
    attr_accessor :f_pair_position
    alias_method :attr_f_pair_position, :f_pair_position
    undef_method :f_pair_position
    alias_method :attr_f_pair_position=, :f_pair_position=
    undef_method :f_pair_position=
    
    # The anchor indicating whether the character is left or right of the caret
    attr_accessor :f_anchor
    alias_method :attr_f_anchor, :f_anchor
    undef_method :f_anchor
    alias_method :attr_f_anchor=, :f_anchor=
    undef_method :f_anchor=
    
    typesig { [ISourceViewer, ICharacterPairMatcher] }
    # Creates a new MatchingCharacterPainter for the given source viewer using the given character
    # pair matcher. The character matcher is not adopted by this painter. Thus, it is not disposed.
    # However, this painter requires exclusive access to the given pair matcher.
    # 
    # @param sourceViewer the source viewer
    # @param matcher the character pair matcher
    def initialize(source_viewer, matcher)
      @f_is_active = false
      @f_source_viewer = nil
      @f_text_widget = nil
      @f_color = nil
      @f_paint_position_manager = nil
      @f_matcher = nil
      @f_pair_position = Position.new(0, 0)
      @f_anchor = 0
      @f_source_viewer = source_viewer
      @f_matcher = matcher
      @f_text_widget = source_viewer.get_text_widget
    end
    
    typesig { [Color] }
    # Sets the color in which to highlight the match character.
    # 
    # @param color the color
    def set_color(color)
      @f_color = color
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.IPainter#dispose()
    def dispose
      if (!(@f_matcher).nil?)
        @f_matcher.clear
        @f_matcher = nil
      end
      @f_color = nil
      @f_text_widget = nil
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.IPainter#deactivate(boolean)
    def deactivate(redraw)
      if (@f_is_active)
        @f_is_active = false
        @f_text_widget.remove_paint_listener(self)
        if (!(@f_paint_position_manager).nil?)
          @f_paint_position_manager.unmanage_position(@f_pair_position)
        end
        if (redraw)
          handle_draw_request(nil)
        end
      end
    end
    
    typesig { [PaintEvent] }
    # @see org.eclipse.swt.events.PaintListener#paintControl(org.eclipse.swt.events.PaintEvent)
    def paint_control(event)
      if (!(@f_text_widget).nil?)
        handle_draw_request(event.attr_gc)
      end
    end
    
    typesig { [SwtGC] }
    # Handles a redraw request.
    # 
    # @param gc the GC to draw into.
    def handle_draw_request(gc)
      if (@f_pair_position.attr_is_deleted)
        return
      end
      offset = @f_pair_position.get_offset
      length = @f_pair_position.get_length
      if (length < 1)
        return
      end
      if (@f_source_viewer.is_a?(ITextViewerExtension5))
        extension = @f_source_viewer
        widget_range = extension.model_range2widget_range(Region.new(offset, length))
        if ((widget_range).nil?)
          return
        end
        begin
          # don't draw if the pair position is really hidden and widgetRange just
          # marks the coverage around it.
          doc = @f_source_viewer.get_document
          start_line = doc.get_line_of_offset(offset)
          end_line = doc.get_line_of_offset(offset + length)
          if ((extension.model_line2widget_line(start_line)).equal?(-1) || (extension.model_line2widget_line(end_line)).equal?(-1))
            return
          end
        rescue BadLocationException => e
          return
        end
        offset = widget_range.get_offset
        length = widget_range.get_length
      else
        region = @f_source_viewer.get_visible_region
        if (region.get_offset > offset || region.get_offset + region.get_length < offset + length)
          return
        end
        offset -= region.get_offset
      end
      if ((ICharacterPairMatcher::RIGHT).equal?(@f_anchor))
        draw(gc, offset, 1)
      else
        draw(gc, offset + length - 1, 1)
      end
    end
    
    typesig { [SwtGC, ::Java::Int, ::Java::Int] }
    # Highlights the given widget region.
    # 
    # @param gc the GC to draw into
    # @param offset the offset of the widget region
    # @param length the length of the widget region
    def draw(gc, offset, length)
      if (!(gc).nil?)
        gc.set_foreground(@f_color)
        bounds = nil
        if (length > 0)
          bounds = @f_text_widget.get_text_bounds(offset, offset + length - 1)
        else
          loc = @f_text_widget.get_location_at_offset(offset)
          bounds = Rectangle.new(loc.attr_x, loc.attr_y, 1, @f_text_widget.get_line_height(offset))
        end
        # draw box around line segment
        gc.draw_rectangle(bounds.attr_x, bounds.attr_y, bounds.attr_width - 1, bounds.attr_height - 1)
        # draw box around character area
        # int widgetBaseline= fTextWidget.getBaseline();
        # FontMetrics fm= gc.getFontMetrics();
        # int fontBaseline= fm.getAscent() + fm.getLeading();
        # int fontBias= widgetBaseline - fontBaseline;
        # gc.drawRectangle(left.x, left.y + fontBias, right.x - left.x - 1, fm.getHeight() - 1);
      else
        @f_text_widget.redraw_range(offset, length, true)
      end
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.IPainter#paint(int)
    def paint(reason)
      document = @f_source_viewer.get_document
      if ((document).nil?)
        deactivate(false)
        return
      end
      selection = @f_source_viewer.get_selected_range
      if (selection.attr_y > 0)
        deactivate(true)
        return
      end
      pair = @f_matcher.match(document, selection.attr_x)
      if ((pair).nil?)
        deactivate(true)
        return
      end
      if (@f_is_active)
        if ((IPainter::CONFIGURATION).equal?(reason))
          # redraw current highlighting
          handle_draw_request(nil)
        else
          if (!(pair.get_offset).equal?(@f_pair_position.get_offset) || !(pair.get_length).equal?(@f_pair_position.get_length) || !(@f_matcher.get_anchor).equal?(@f_anchor))
            # otherwise only do something if position is different
            # remove old highlighting
            handle_draw_request(nil)
            # update position
            @f_pair_position.attr_is_deleted = false
            @f_pair_position.attr_offset = pair.get_offset
            @f_pair_position.attr_length = pair.get_length
            @f_anchor = @f_matcher.get_anchor
            # apply new highlighting
            handle_draw_request(nil)
          end
        end
      else
        @f_is_active = true
        @f_pair_position.attr_is_deleted = false
        @f_pair_position.attr_offset = pair.get_offset
        @f_pair_position.attr_length = pair.get_length
        @f_anchor = @f_matcher.get_anchor
        @f_text_widget.add_paint_listener(self)
        @f_paint_position_manager.manage_position(@f_pair_position)
        handle_draw_request(nil)
      end
    end
    
    typesig { [IPaintPositionManager] }
    # @see org.eclipse.jface.text.IPainter#setPositionManager(org.eclipse.jface.text.IPaintPositionManager)
    def set_position_manager(manager)
      @f_paint_position_manager = manager
    end
    
    private
    alias_method :initialize__matching_character_painter, :initialize
  end
  
end
