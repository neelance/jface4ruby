require "rjava"

# Copyright (c) 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Internal::Text
  module InternalAccessorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Internal::Text
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
      include_const ::Org::Eclipse::Jface::Text, :AbstractInformationControlManager
      include_const ::Org::Eclipse::Jface::Text, :IInformationControl
      include_const ::Org::Eclipse::Jface::Text, :IInformationControlExtension3
      include_const ::Org::Eclipse::Jface::Text, :ITextViewerExtension8
      include_const ::Org::Eclipse::Jface::Text::ITextViewerExtension8, :EnrichMode
    }
  end
  
  # An internal class that gives access to internal methods of {@link
  # AbstractInformationControlManager} and subclasses.
  # 
  # @since 3.4
  class InternalAccessor 
    include_class_members InternalAccessorImports
    
    typesig { [] }
    # Returns the current information control, or <code>null</code> if none.
    # 
    # @return the current information control, or <code>null</code> if none
    def get_current_information_control
      raise NotImplementedError
    end
    
    typesig { [InformationControlReplacer] }
    # Sets the information control replacer for this manager and disposes the
    # old one if set.
    # 
    # @param replacer the information control replacer for this manager, or
    # <code>null</code> if no information control replacing should
    # take place
    def set_information_control_replacer(replacer)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the current information control replacer or <code>null</code> if none has been installed.
    # 
    # @return the current information control replacer or <code>null</code> if none has been installed
    def get_information_control_replacer
      raise NotImplementedError
    end
    
    typesig { [IInformationControl] }
    # Tests whether the given information control is replaceable.
    # 
    # @param iControl information control or <code>null</code> if none
    # @return <code>true</code> if information control is replaceable, <code>false</code> otherwise
    def can_replace(i_control)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells whether this manager's information control is currently being replaced.
    # 
    # @return <code>true</code> if a replace is in progress
    def is_replace_in_progress
      raise NotImplementedError
    end
    
    typesig { [Rectangle] }
    # Crops the given bounds such that they lie completely on the closest monitor.
    # 
    # @param bounds shell bounds to crop
    def crop_to_closest_monitor(bounds)
      raise NotImplementedError
    end
    
    typesig { [EnrichMode] }
    # Sets the hover enrich mode. Only applicable when an information
    # control replacer has been set with
    # {@link #setInformationControlReplacer(InformationControlReplacer)} .
    # 
    # @param mode the enrich mode
    # @see ITextViewerExtension8#setHoverEnrichMode(org.eclipse.jface.text.ITextViewerExtension8.EnrichMode)
    def set_hover_enrich_mode(mode)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Indicates whether the mouse cursor is allowed to leave the subject area without closing the hover.
    # 
    # @return whether the mouse cursor is allowed to leave the subject area without closing the hover
    def get_allow_mouse_exit
      raise NotImplementedError
    end
    
    typesig { [::Java::Boolean] }
    # Replaces this manager's information control as defined by
    # the information control replacer.
    # <strong>Must only be called when the information control is instanceof {@link IInformationControlExtension3}!</strong>
    # 
    # @param takeFocus <code>true</code> iff the replacing information control should take focus
    def replace_information_control(take_focus)
      raise NotImplementedError
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__internal_accessor, :initialize
  end
  
end
