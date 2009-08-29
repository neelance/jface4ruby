require "rjava"

# Copyright (c) 2000, 2008 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Viewers
  module ArrayContentProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Viewers
      include_const ::Java::Util, :Collection
    }
  end
  
  # This implementation of <code>IStructuredContentProvider</code> handles
  # the case where the viewer input is an unchanging array or collection of elements.
  # <p>
  # This class is not intended to be subclassed outside the viewer framework.
  # </p>
  # 
  # @since 2.1
  # @noextend This class is not intended to be subclassed by clients.
  class ArrayContentProvider 
    include_class_members ArrayContentProviderImports
    include IStructuredContentProvider
    
    class_module.module_eval {
      
      def instance
        defined?(@@instance) ? @@instance : @@instance= nil
      end
      alias_method :attr_instance, :instance
      
      def instance=(value)
        @@instance = value
      end
      alias_method :attr_instance=, :instance=
      
      typesig { [] }
      # Returns an instance of ArrayContentProvider. Since instances of this
      # class do not maintain any state, they can be shared between multiple
      # clients.
      # 
      # @return an instance of ArrayContentProvider
      # 
      # @since 3.5
      def get_instance
        synchronized((ArrayContentProvider)) do
          if ((self.attr_instance).nil?)
            self.attr_instance = ArrayContentProvider.new
          end
          return self.attr_instance
        end
      end
    }
    
    typesig { [Object] }
    # Returns the elements in the input, which must be either an array or a
    # <code>Collection</code>.
    def get_elements(input_element)
      if (input_element.is_a?(Array.typed(Object)))
        return input_element
      end
      if (input_element.is_a?(Collection))
        return (input_element).to_array
      end
      return Array.typed(Object).new(0) { nil }
    end
    
    typesig { [Viewer, Object, Object] }
    # This implementation does nothing.
    def input_changed(viewer, old_input, new_input)
      # do nothing.
    end
    
    typesig { [] }
    # This implementation does nothing.
    def dispose
      # do nothing.
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__array_content_provider, :initialize
  end
  
end
