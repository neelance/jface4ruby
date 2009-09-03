require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text
  module IInformationControlExtension3Imports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text
      include_const ::Org::Eclipse::Swt::Graphics, :Rectangle
    }
  end
  
  # Extension interface for {@link org.eclipse.jface.text.IInformationControl}.
  # Adds API which allows to get this information control's bounds and introduces
  # the concept of persistent size and location by introducing predicates for
  # whether the information control supports restoring of size and location.
  # <p>
  # Note: An information control which implements this interface can ignore calls
  # to
  # {@link org.eclipse.jface.text.IInformationControl#setSizeConstraints(int, int)}
  # or use it as hint for its very first appearance.
  # </p>
  # 
  # @see org.eclipse.jface.text.IInformationControl
  # @since 3.0
  module IInformationControlExtension3
    include_class_members IInformationControlExtension3Imports
    
    typesig { [] }
    # Returns a rectangle describing the receiver's size and location
    # relative to its parent (or its display if its parent is null).
    # <p>
    # Note: If the receiver is already disposed then this methods must
    # return the last valid location and size.
    # </p>
    # 
    # @return the receiver's bounding rectangle
    def get_bounds
      raise NotImplementedError
    end
    
    typesig { [] }
    # Computes the trim for this control. The trim is the space around the
    # information control's actual content area. It includes all borders of the
    # control and other static content placed around the content area (e.g. a
    # toolbar).
    # 
    # @return The receiver's trim. <code>x</code> and <code>y</code> denote
    # the upper left corner of the trimming relative to this control's
    # location i.e. this will most likely be negative values.
    # <code>width</code> and <code>height</code> represent the
    # border sizes (the sum of the horizontal and vertical trimmings,
    # respectively).
    def compute_trim
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells whether this control allows to restore the previously
    # used size.
    # <p>
    # Note: This is not a static property - it can change during the
    # lifetime of this control.</p>
    # 
    # @return <code>true</code> if restoring size is supported
    def restores_size
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells whether this control allows to restore the previously
    # used location.
    # <p>
    # Note: This is not a static property - it can change during the
    # lifetime of this control.</p>
    # 
    # @return <code>true</code> if restoring location is supported
    def restores_location
      raise NotImplementedError
    end
  end
  
end
