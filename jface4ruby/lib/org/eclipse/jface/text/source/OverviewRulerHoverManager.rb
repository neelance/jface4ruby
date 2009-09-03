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
  module OverviewRulerHoverManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Source
      include_const ::Org::Eclipse::Swt::Custom, :StyledText
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Swt::Widgets, :ScrollBar
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlCreator
    }
  end
  
  # This manager controls the layout, content, and visibility of an information
  # control in reaction to mouse hover events issued by the overview ruler of a
  # source viewer.
  # 
  # @since 2.1
  class OverviewRulerHoverManager < OverviewRulerHoverManagerImports.const_get :AnnotationBarHoverManager
    include_class_members OverviewRulerHoverManagerImports
    
    typesig { [IOverviewRuler, ISourceViewer, IAnnotationHover, IInformationControlCreator] }
    # Creates an overview hover manager with the given parameters. In addition,
    # the hovers anchor is RIGHT and the margin is 5 points to the right.
    # 
    # @param ruler the overview ruler this manager connects to
    # @param sourceViewer the source viewer this manager connects to
    # @param annotationHover the annotation hover providing the information to be displayed
    # @param creator the information control creator
    def initialize(ruler, source_viewer, annotation_hover, creator)
      super(ruler, source_viewer, annotation_hover, creator)
      set_anchor(ANCHOR_LEFT)
      text_widget = source_viewer.get_text_widget
      if (!(text_widget).nil?)
        vertical_bar = text_widget.get_vertical_bar
        if (!(vertical_bar).nil?)
          set_margins(vertical_bar.get_size.attr_x, 5)
        end
      end
    end
    
    typesig { [] }
    # @see AbstractHoverInformationControlManager#computeInformation()
    def compute_information
      location = get_hover_event_location
      line = get_vertical_ruler_info.to_document_line_number(location.attr_y)
      hover = get_annotation_hover
      control_creator = nil
      if (hover.is_a?(IAnnotationHoverExtension))
        control_creator = (hover).get_hover_control_creator
      end
      set_custom_information_control_creator(control_creator)
      set_information(hover.get_hover_info(get_source_viewer, line), compute_area(location.attr_y))
    end
    
    typesig { [::Java::Int] }
    # Determines graphical area covered for which the hover is valid.
    # 
    # @param y y-coordinate in the vertical ruler
    # @return the graphical extend where the hover is valid
    def compute_area(y)
      # This is OK (see constructor)
      overview_ruler = get_vertical_ruler_info
      hover_height = overview_ruler.get_annotation_height
      hover_width = get_vertical_ruler_info.get_control.get_size.attr_x
      # Calculate y-coordinate for hover
      hover_y = y
      has_annotation = true
      while (has_annotation && hover_y > y - hover_height)
        hover_y -= 1
        has_annotation = overview_ruler.has_annotation(hover_y)
      end
      hover_y += 1
      return Rectangle.new(0, hover_y, hover_width, hover_height)
    end
    
    private
    alias_method :initialize__overview_ruler_hover_manager, :initialize
  end
  
end
