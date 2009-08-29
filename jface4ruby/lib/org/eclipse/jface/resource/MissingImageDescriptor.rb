require "rjava"

# Copyright (c) 2000, 2006 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
# IBM Corporation - initial API and implementation
module Org::Eclipse::Jface::Resource
  module MissingImageDescriptorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Org::Eclipse::Jface::Resource
      include_const ::Org::Eclipse::Swt::Graphics, :ImageData
    }
  end
  
  # The image descriptor for a missing image.
  # <p>
  # Use <code>MissingImageDescriptor.getInstance</code> to
  # access the singleton instance maintained in an
  # internal state variable.
  # </p>
  class MissingImageDescriptor < MissingImageDescriptorImports.const_get :ImageDescriptor
    include_class_members MissingImageDescriptorImports
    
    class_module.module_eval {
      
      def instance
        defined?(@@instance) ? @@instance : @@instance= nil
      end
      alias_method :attr_instance, :instance
      
      def instance=(value)
        @@instance = value
      end
      alias_method :attr_instance=, :instance=
    }
    
    typesig { [] }
    # Constructs a new missing image descriptor.
    def initialize
      super()
    end
    
    typesig { [] }
    # (non-Javadoc)
    # Method declared on ImageDesciptor.
    def get_image_data
      return DEFAULT_IMAGE_DATA
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns the shared missing image descriptor instance.
      # 
      # @return the image descriptor for a missing image
      def get_instance
        if ((self.attr_instance).nil?)
          self.attr_instance = MissingImageDescriptor.new
        end
        return self.attr_instance
      end
    }
    
    private
    alias_method :initialize__missing_image_descriptor, :initialize
  end
  
end
