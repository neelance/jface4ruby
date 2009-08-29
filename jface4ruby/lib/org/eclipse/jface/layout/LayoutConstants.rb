require "rjava"

# Copyright (c) 2005, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Layout
  module LayoutConstantsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Layout
      include_const ::Org::Eclipse::Jface::Dialogs, :Dialog
      include_const ::Org::Eclipse::Jface::Dialogs, :IDialogConstants
      include_const ::Org::Eclipse::Jface::Resource, :JFaceResources
      include_const ::Org::Eclipse::Swt::Graphics, :FontMetrics
      include_const ::Org::Eclipse::Swt::Graphics, :GC
      include_const ::Org::Eclipse::Swt::Graphics, :Point
      include_const ::Org::Eclipse::Swt::Widgets, :Display
    }
  end
  
  # Contains various layout constants
  # 
  # @since 3.2
  class LayoutConstants 
    include_class_members LayoutConstantsImports
    
    class_module.module_eval {
      
      def dialog_margins
        defined?(@@dialog_margins) ? @@dialog_margins : @@dialog_margins= nil
      end
      alias_method :attr_dialog_margins, :dialog_margins
      
      def dialog_margins=(value)
        @@dialog_margins = value
      end
      alias_method :attr_dialog_margins=, :dialog_margins=
      
      
      def dialog_spacing
        defined?(@@dialog_spacing) ? @@dialog_spacing : @@dialog_spacing= nil
      end
      alias_method :attr_dialog_spacing, :dialog_spacing
      
      def dialog_spacing=(value)
        @@dialog_spacing = value
      end
      alias_method :attr_dialog_spacing=, :dialog_spacing=
      
      
      def min_button_size
        defined?(@@min_button_size) ? @@min_button_size : @@min_button_size= nil
      end
      alias_method :attr_min_button_size, :min_button_size
      
      def min_button_size=(value)
        @@min_button_size = value
      end
      alias_method :attr_min_button_size=, :min_button_size=
      
      typesig { [] }
      def initialize_constants
        if (!(self.attr_dialog_margins).nil?)
          return
        end
        gc = GC.new(Display.get_current)
        gc.set_font(JFaceResources.get_dialog_font)
        font_metrics = gc.get_font_metrics
        self.attr_dialog_margins = Point.new(Dialog.convert_horizontal_dlus_to_pixels(font_metrics, IDialogConstants::HORIZONTAL_MARGIN), Dialog.convert_vertical_dlus_to_pixels(font_metrics, IDialogConstants::VERTICAL_MARGIN))
        self.attr_dialog_spacing = Point.new(Dialog.convert_horizontal_dlus_to_pixels(font_metrics, IDialogConstants::HORIZONTAL_SPACING), Dialog.convert_vertical_dlus_to_pixels(font_metrics, IDialogConstants::VERTICAL_SPACING))
        self.attr_min_button_size = Point.new(Dialog.convert_horizontal_dlus_to_pixels(font_metrics, IDialogConstants::BUTTON_WIDTH), 0)
        gc.dispose
      end
      
      typesig { [] }
      # Returns the default dialog margins, in pixels
      # 
      # @return the default dialog margins, in pixels
      def get_margins
        initialize_constants
        return self.attr_dialog_margins
      end
      
      typesig { [] }
      # Returns the default dialog spacing, in pixels
      # 
      # @return the default dialog spacing, in pixels
      def get_spacing
        initialize_constants
        return self.attr_dialog_spacing
      end
      
      typesig { [] }
      # Returns the default minimum button size, in pixels
      # 
      # @return the default minimum button size, in pixels
      def get_min_button_size
        initialize_constants
        return self.attr_min_button_size
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__layout_constants, :initialize
  end
  
end
