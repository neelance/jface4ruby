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
  module LineNumberChangeRulerColumnImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Graphics, :Color
      include_const ::Org::Eclipse::Swt::Graphics, :SwtGC
      include_const ::Org::Eclipse::Swt::Widgets, :Composite
      include_const ::Org::Eclipse::Swt::Widgets, :Control
      include_const ::Org::Eclipse::Core::Runtime, :Assert
      include_const ::Org::Eclipse::Jface::Internal::Text::Revisions, :RevisionPainter
      include_const ::Org::Eclipse::Jface::Internal::Text::Source, :DiffPainter
      include_const ::Org::Eclipse::Jface::Viewers, :ISelectionProvider
      include_const ::Org::Eclipse::Jface::Text::Revisions, :IRevisionListener
      include_const ::Org::Eclipse::Jface::Text::Revisions, :IRevisionRulerColumn
      include_const ::Org::Eclipse::Jface::Text::Revisions, :IRevisionRulerColumnExtension
      include_const ::Org::Eclipse::Jface::Text::Revisions, :RevisionInformation
    }
  end
  
  # A vertical ruler column displaying line numbers and serving as a UI for quick diff.
  # Clients usually instantiate and configure object of this class.
  # 
  # @since 3.0
  class LineNumberChangeRulerColumn < LineNumberChangeRulerColumnImports.const_get :LineNumberRulerColumn
    include_class_members LineNumberChangeRulerColumnImports
    overload_protected {
      include IVerticalRulerInfo
      include IVerticalRulerInfoExtension
      include IChangeRulerColumn
      include IRevisionRulerColumn
      include IRevisionRulerColumnExtension
    }
    
    # The ruler's annotation model.
    attr_accessor :f_annotation_model
    alias_method :attr_f_annotation_model, :f_annotation_model
    undef_method :f_annotation_model
    alias_method :attr_f_annotation_model=, :f_annotation_model=
    undef_method :f_annotation_model=
    
    # <code>true</code> if changes should be displayed using character indications instead of background colors.
    attr_accessor :f_character_display
    alias_method :attr_f_character_display, :f_character_display
    undef_method :f_character_display
    alias_method :attr_f_character_display=, :f_character_display=
    undef_method :f_character_display=
    
    # The revision painter strategy.
    # 
    # @since 3.2
    attr_accessor :f_revision_painter
    alias_method :attr_f_revision_painter, :f_revision_painter
    undef_method :f_revision_painter
    alias_method :attr_f_revision_painter=, :f_revision_painter=
    undef_method :f_revision_painter=
    
    # The diff information painter strategy.
    # 
    # @since 3.2
    attr_accessor :f_diff_painter
    alias_method :attr_f_diff_painter, :f_diff_painter
    undef_method :f_diff_painter
    alias_method :attr_f_diff_painter=, :f_diff_painter=
    undef_method :f_diff_painter=
    
    # Whether to show number or to behave like a change ruler column.
    # @since 3.3
    attr_accessor :f_show_numbers
    alias_method :attr_f_show_numbers, :f_show_numbers
    undef_method :f_show_numbers
    alias_method :attr_f_show_numbers=, :f_show_numbers=
    undef_method :f_show_numbers=
    
    typesig { [ISharedTextColors] }
    # Creates a new instance.
    # 
    # @param sharedColors the shared colors provider to use
    def initialize(shared_colors)
      @f_annotation_model = nil
      @f_character_display = false
      @f_revision_painter = nil
      @f_diff_painter = nil
      @f_show_numbers = false
      super()
      @f_show_numbers = true
      Assert.is_not_null(shared_colors)
      @f_revision_painter = RevisionPainter.new(self, shared_colors)
      @f_diff_painter = DiffPainter.new(self, shared_colors)
    end
    
    typesig { [CompositeRuler, Composite] }
    # @see org.eclipse.jface.text.source.LineNumberRulerColumn#createControl(org.eclipse.jface.text.source.CompositeRuler, org.eclipse.swt.widgets.Composite)
    def create_control(parent_ruler, parent_control)
      control = super(parent_ruler, parent_control)
      @f_revision_painter.set_parent_ruler(parent_ruler)
      @f_diff_painter.set_parent_ruler(parent_ruler)
      return control
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
    def get_line_of_last_mouse_button_activity
      return get_parent_ruler.get_line_of_last_mouse_button_activity
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfo#toDocumentLineNumber(int)
    def to_document_line_number(y_coordinate)
      return get_parent_ruler.to_document_line_number(y_coordinate)
    end
    
    typesig { [IAnnotationModel] }
    # @see IVerticalRulerColumn#setModel(IAnnotationModel)
    def set_model(model)
      set_annotation_model(model)
      @f_revision_painter.set_model(model)
      @f_diff_painter.set_model(model)
      update_number_of_digits
      compute_indentations
      layout(true)
      post_redraw
    end
    
    typesig { [IAnnotationModel] }
    def set_annotation_model(model)
      if (!(@f_annotation_model).equal?(model))
        @f_annotation_model = model
      end
    end
    
    typesig { [::Java::Boolean] }
    # Sets the display mode of the ruler. If character mode is set to <code>true</code>, diff
    # information will be displayed textually on the line number ruler.
    # 
    # @param characterMode <code>true</code> if diff information is to be displayed textually.
    def set_display_mode(character_mode)
      if (!(character_mode).equal?(@f_character_display))
        @f_character_display = character_mode
        update_number_of_digits
        compute_indentations
        layout(true)
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#getModel()
    def get_model
      return @f_annotation_model
    end
    
    typesig { [::Java::Int] }
    # @see org.eclipse.jface.text.source.LineNumberRulerColumn#createDisplayString(int)
    def create_display_string(line)
      buffer = StringBuffer.new
      if (@f_show_numbers)
        buffer.append(super(line))
      end
      if (@f_character_display && !(get_model).nil?)
        buffer.append(@f_diff_painter.get_display_character(line))
      end
      return buffer.to_s
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.LineNumberRulerColumn#computeNumberOfDigits()
    def compute_number_of_digits
      digits = 0
      if (@f_character_display && !(get_model).nil?)
        if (@f_show_numbers)
          digits = super + 1
        else
          digits = 1
        end
      else
        if (@f_show_numbers)
          digits = super
        else
          digits = 0
        end
      end
      if (@f_revision_painter.has_information)
        digits += @f_revision_painter.get_required_width
      end
      return digits
    end
    
    typesig { [IVerticalRulerListener] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#addVerticalRulerListener(org.eclipse.jface.text.source.IVerticalRulerListener)
    def add_vertical_ruler_listener(listener)
      raise UnsupportedOperationException.new
    end
    
    typesig { [IVerticalRulerListener] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#removeVerticalRulerListener(org.eclipse.jface.text.source.IVerticalRulerListener)
    def remove_vertical_ruler_listener(listener)
      raise UnsupportedOperationException.new
    end
    
    typesig { [SwtGC, ILineRange] }
    # @see org.eclipse.jface.text.source.LineNumberRulerColumn#doPaint(org.eclipse.swt.graphics.GC)
    def do_paint(gc, visible_lines)
      foreground = gc.get_foreground
      if (!(visible_lines).nil?)
        if (@f_revision_painter.has_information)
          @f_revision_painter.paint(gc, visible_lines)
        else
          if (@f_diff_painter.has_information)
            # don't paint quick diff colors if revisions are painted
            @f_diff_painter.paint(gc, visible_lines)
          end
        end
      end
      gc.set_foreground(foreground)
      if (@f_show_numbers || @f_character_display)
        super(gc, visible_lines)
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.IVerticalRulerInfoExtension#getHover()
    def get_hover
      active_line = get_parent_ruler.get_line_of_last_mouse_button_activity
      if (@f_revision_painter.has_hover(active_line))
        return @f_revision_painter.get_hover
      end
      if (@f_diff_painter.has_hover(active_line))
        return @f_diff_painter.get_hover
      end
      return nil
    end
    
    typesig { [IAnnotationHover] }
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setHover(org.eclipse.jface.text.source.IAnnotationHover)
    def set_hover(hover)
      @f_revision_painter.set_hover(hover)
      @f_diff_painter.set_hover(hover)
    end
    
    typesig { [Color] }
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setBackground(org.eclipse.swt.graphics.Color)
    def set_background(background)
      super(background)
      @f_revision_painter.set_background(background)
      @f_diff_painter.set_background(background)
    end
    
    typesig { [Color] }
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setAddedColor(org.eclipse.swt.graphics.Color)
    def set_added_color(added_color)
      @f_diff_painter.set_added_color(added_color)
    end
    
    typesig { [Color] }
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setChangedColor(org.eclipse.swt.graphics.Color)
    def set_changed_color(changed_color)
      @f_diff_painter.set_changed_color(changed_color)
    end
    
    typesig { [Color] }
    # @see org.eclipse.jface.text.source.IChangeRulerColumn#setDeletedColor(org.eclipse.swt.graphics.Color)
    def set_deleted_color(deleted_color)
      @f_diff_painter.set_deleted_color(deleted_color)
    end
    
    typesig { [RevisionInformation] }
    # @see org.eclipse.jface.text.revisions.IRevisionRulerColumn#setRevisionInformation(org.eclipse.jface.text.revisions.RevisionInformation)
    def set_revision_information(info)
      @f_revision_painter.set_revision_information(info)
      update_number_of_digits
      compute_indentations
      layout(true)
      post_redraw
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.revisions.IRevisionRulerColumnExtension#getRevisionSelectionProvider()
    # @since 3.2
    def get_revision_selection_provider
      return @f_revision_painter.get_revision_selection_provider
    end
    
    typesig { [RenderingMode] }
    # @see org.eclipse.jface.text.revisions.IRevisionRulerColumnExtension#setRenderingMode(org.eclipse.jface.text.revisions.IRevisionRulerColumnExtension.RenderingMode)
    # @since 3.3
    def set_revision_rendering_mode(rendering_mode)
      @f_revision_painter.set_rendering_mode(rendering_mode)
    end
    
    typesig { [::Java::Boolean] }
    # Sets the line number display mode.
    # 
    # @param showNumbers <code>true</code> to show numbers, <code>false</code> to only show
    # diff / revision info.
    # @since 3.3
    def show_line_numbers(show_numbers)
      if (!(@f_show_numbers).equal?(show_numbers))
        @f_show_numbers = show_numbers
        update_number_of_digits
        compute_indentations
        layout(true)
      end
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.LineNumberRulerColumn#getWidth()
    # @since 3.3
    def get_width
      width = super
      return width > 0 ? width : 8 # minimal width to display quick diff / revisions if no textual info is shown
    end
    
    typesig { [] }
    # Returns <code>true</code> if the ruler is showing line numbers, <code>false</code>
    # otherwise
    # 
    # @return <code>true</code> if line numbers are shown, <code>false</code> otherwise
    # @since 3.3
    def is_showing_line_numbers
      return @f_show_numbers
    end
    
    typesig { [] }
    # Returns <code>true</code> if the ruler is showing revision information, <code>false</code>
    # otherwise
    # 
    # @return <code>true</code> if revision information is shown, <code>false</code> otherwise
    # @since 3.3
    def is_showing_revision_information
      return @f_revision_painter.has_information
    end
    
    typesig { [] }
    # Returns <code>true</code> if the ruler is showing change information, <code>false</code>
    # otherwise
    # 
    # @return <code>true</code> if change information is shown, <code>false</code> otherwise
    # @since 3.3
    def is_showing_change_information
      return @f_diff_painter.has_information
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.revisions.IRevisionRulerColumnExtension#showRevisionAuthor(boolean)
    # @since 3.3
    def show_revision_author(show)
      @f_revision_painter.show_revision_author(show)
      update_number_of_digits
      compute_indentations
      layout(true)
      post_redraw
    end
    
    typesig { [::Java::Boolean] }
    # @see org.eclipse.jface.text.revisions.IRevisionRulerColumnExtension#showRevisionId(boolean)
    # @since 3.3
    def show_revision_id(show)
      @f_revision_painter.show_revision_id(show)
      update_number_of_digits
      compute_indentations
      layout(true)
      post_redraw
    end
    
    typesig { [IRevisionListener] }
    # @see org.eclipse.jface.text.revisions.IRevisionRulerColumnExtension#addRevisionListener(org.eclipse.jface.text.revisions.IRevisionListener)
    # @since 3.3
    def add_revision_listener(listener)
      @f_revision_painter.add_revision_listener(listener)
    end
    
    typesig { [IRevisionListener] }
    # @see org.eclipse.jface.text.revisions.IRevisionRulerColumnExtension#removeRevisionListener(org.eclipse.jface.text.revisions.IRevisionListener)
    # @since 3.3
    def remove_revision_listener(listener)
      @f_revision_painter.remove_revision_listener(listener)
    end
    
    typesig { [] }
    # @see org.eclipse.jface.text.source.LineNumberRulerColumn#handleDispose()
    # @since 3.3
    def handle_dispose
      @f_revision_painter.set_parent_ruler(nil)
      @f_revision_painter.set_model(nil)
      @f_diff_painter.set_parent_ruler(nil)
      @f_diff_painter.set_model(nil)
      super
    end
    
    private
    alias_method :initialize__line_number_change_ruler_column, :initialize
  end
  
end
