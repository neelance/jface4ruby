require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Text::Projection
  module SegmentImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # Internal class. Do not use. Only public for testing purposes.
  # <p>
  # A segment is the image of a master document fragment in a projection
  # document.
  # 
  # @since 3.0
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class Segment < SegmentImports.const_get :Position
    include_class_members SegmentImports
    
    # The corresponding fragment for this segment.
    attr_accessor :fragment
    alias_method :attr_fragment, :fragment
    undef_method :fragment
    alias_method :attr_fragment=, :fragment=
    undef_method :fragment=
    
    # A flag indicating that the segment updater should stretch this segment when a change happens at its boundaries.
    attr_accessor :is_marked_for_stretch
    alias_method :attr_is_marked_for_stretch, :is_marked_for_stretch
    undef_method :is_marked_for_stretch
    alias_method :attr_is_marked_for_stretch=, :is_marked_for_stretch=
    undef_method :is_marked_for_stretch=
    
    # A flag indicating that the segment updater should shift this segment when a change happens at its boundaries.
    attr_accessor :is_marked_for_shift
    alias_method :attr_is_marked_for_shift, :is_marked_for_shift
    undef_method :is_marked_for_shift
    alias_method :attr_is_marked_for_shift=, :is_marked_for_shift=
    undef_method :is_marked_for_shift=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a new segment covering the given range.
    # 
    # @param offset the offset of the segment
    # @param length the length of the segment
    def initialize(offset, length)
      @fragment = nil
      @is_marked_for_stretch = false
      @is_marked_for_shift = false
      super(offset, length)
    end
    
    typesig { [] }
    # Sets the stretching flag.
    def mark_for_stretch
      @is_marked_for_stretch = true
    end
    
    typesig { [] }
    # Returns <code>true</code> if the stretching flag is set, <code>false</code> otherwise.
    # @return <code>true</code> if the stretching flag is set, <code>false</code> otherwise
    def is_marked_for_stretch
      return @is_marked_for_stretch
    end
    
    typesig { [] }
    # Sets the shifting flag.
    def mark_for_shift
      @is_marked_for_shift = true
    end
    
    typesig { [] }
    # Returns <code>true</code> if the shifting flag is set, <code>false</code> otherwise.
    # @return <code>true</code> if the shifting flag is set, <code>false</code> otherwise
    def is_marked_for_shift
      return @is_marked_for_shift
    end
    
    typesig { [] }
    # Clears the shifting and the stretching flag.
    def clear_mark
      @is_marked_for_stretch = false
      @is_marked_for_shift = false
    end
    
    private
    alias_method :initialize__segment, :initialize
  end
  
end
