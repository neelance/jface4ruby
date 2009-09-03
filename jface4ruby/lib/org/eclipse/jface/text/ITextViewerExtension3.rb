require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module ITextViewerExtension3Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.ITextViewer}. <p>
  # This interface has been replaced by {@link org.eclipse.jface.text.ITextViewerExtension5}.
  # Clients are not supposed to use this interface any longer.
  # 
  # @since 2.1
  # @deprecated replaced by {@link org.eclipse.jface.text.ITextViewerExtension5}
  module ITextViewerExtension3
    include_class_members ITextViewerExtension3Imports
    
    typesig { [] }
    # Returns the minimal region of the viewer's document that completely comprises everything that is
    # visible in the viewer's widget or <code>null</code> if there is no such region.
    # 
    # @return the minimal region of the viewer's document comprising the contents of the viewer's widget or <code>null</code>
    def get_model_coverage
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the widget line that corresponds to the given line of the viewer's document or <code>-1</code> if there is no such line.
    # 
    # @param modelLine the line of the viewer's document
    # @return the corresponding widget line or <code>-1</code>
    def model_line2widget_line(model_line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the widget offset that corresponds to the given offset in the viewer's document
    # or <code>-1</code> if there is no such offset
    # 
    # @param modelOffset the offset in the viewer's document
    # @return the corresponding widget offset or <code>-1</code>
    def model_offset2widget_offset(model_offset)
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # Returns the minimal region of the viewer's widget that completely comprises the given region of the
    # viewer's document or <code>null</code> if there is no such region.
    # 
    # @param modelRange the region of the viewer's document
    # @return the minimal region of the widget comprising <code>modelRange</code> or <code>null</code>
    def model_range2widget_range(model_range)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the offset of the viewer's document that corresponds to the given widget offset
    # or <code>-1</code> if there is no such offset
    # 
    # @param widgetOffset the widget offset
    # @return the corresponding offset in the viewer's document or <code>-1</code>
    def widget_offset2model_offset(widget_offset)
      raise NotImplementedError
    end
    
    typesig { [IRegion] }
    # Returns the minimal region of the viewer's document that completely comprises the given widget region
    # or <code>null</code> if there is no such region.
    # 
    # @param widgetRange the widget region
    # @return the minimal region of the viewer's document comprising <code>widgetRange</code> or <code>null</code>
    def widget_range2model_range(widget_range)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the line of the viewer's document that corresponds to the given widget line or <code>-1</code> if there is no such line.
    # 
    # @param widgetLine the widget line
    # @return the corresponding line of the viewer's document or <code>-1</code>
    def widgetl_line2model_line(widget_line)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the widget line of the given widget offset.
    # 
    # @param widgetOffset the widget offset
    # @return the widget line of the widget offset
    def widget_line_of_widget_offset(widget_offset)
      raise NotImplementedError
    end
  end
  
end
