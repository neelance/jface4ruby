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
  module FragmentImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Text::Projection
      include_const ::Org::Eclipse::Jface::Text, :Position
    }
  end
  
  # Internal class. Do not use. Only public for testing purposes.
  # <p>
  # A fragment is a range of the master document that has an image, the so called
  # segment, in a projection document.</p>
  # 
  # @since 3.0
  # @noinstantiate This class is not intended to be instantiated by clients.
  # @noextend This class is not intended to be subclassed by clients.
  class Fragment < FragmentImports.const_get :Position
    include_class_members FragmentImports
    
    # The corresponding segment of this fragment.
    attr_accessor :segment
    alias_method :attr_segment, :segment
    undef_method :segment
    alias_method :attr_segment=, :segment=
    undef_method :segment=
    
    typesig { [::Java::Int, ::Java::Int] }
    # Creates a new fragment covering the given range.
    # 
    # @param offset the offset of the fragment
    # @param length the length of the fragment
    def initialize(offset, length)
      @segment = nil
      super(offset, length)
    end
    
    private
    alias_method :initialize__fragment, :initialize
  end
  
end
